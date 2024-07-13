# defmodule ExampleWeb.AuthController do
#   use ExampleWeb, :controller
#   use AshAuthentication.Phoenix.Controller

#   alias Example.Accounts
#   alias Example.Accounts.UserProfile

#   require Logger

#   def success(conn, activity, user, _token) do
#     user =
#       case activity do
#         {:password, :sign_in} ->
#           user

#         {:password, :register} ->
#           case UserProfile
#                |> Ash.Changeset.for_create(:create, %{
#                  user_id: Map.get(user, :id),
#                  name: Map.get(user, :name)
#                })
#                |> Accounts.create() do
#             {:error, result} ->
#               Logger.error(
#                 "[#{__MODULE__}] Something went wrong creating user profile #{inspect(result)}"
#               )

#               user

#             {:ok, _profile} ->
#               user |> Accounts.load!([:profile])
#           end
#       end

#     return_to =
#       case Map.get(conn.query_params, "redirect_to") do
#         nil ->
#           get_session(conn, :return_to) || ~p"/home"

#         path ->
#           path
#       end

#     conn
#     |> delete_session(:return_to)
#     |> store_in_session(user)
#     |> assign(:current_user, user)
#     |> redirect(to: return_to)
#   end

#   def failure(
#         conn,
#         {:password, :sign_in},
#         %AshAuthentication.Errors.AuthenticationFailed{} = reason
#       ) do
#     conn
#     |> assign(:errors, reason)
#     |> put_flash(
#       :error,
#       "Username or password is incorrect"
#     )
#     |> redirect(to: "/sign-in")
#   end

#   def failure(
#         conn,
#         {:password, :register},
#         reason
#       ) do
#     conn
#     |> assign(:errors, reason)
#     |> put_flash(
#       :error,
#       "Something went wrong. Try again." <>
#         " " <>
#         Enum.map_join(reason.errors, "\n", fn x ->
#           (to_string(x.field) |> String.capitalize()) <> " " <> x.message
#         end)
#     )
#     |> redirect(to: "/register")
#   end

#   def failure(conn, activity, reason) do
#     stacktrace =
#       case reason do
#         %{stacktrace: %{stacktrace: stacktrace}} -> stacktrace
#         _ -> nil
#       end

#     Logger.error("""
#     Something went wrong in authentication

#     activity: #{inspect(activity)}

#     reason: #{Exception.format(:error, reason, stacktrace || [])}
#     """)

#     conn
#     |> put_flash(
#       :error,
#       "Something went wrong"
#     )
#     |> redirect(to: "/sign-in")
#   end

#   def sign_out(conn, _params) do
#     return_to = get_session(conn, :return_to) || "/sign-in"

#     token = Plug.Conn.get_session(conn, "user_token")

#     if token do
#       Accounts.UserToken
#       |> AshAuthentication.TokenResource.Actions.get_token(%{"token" => token})
#       |> case do
#         {:ok, [token]} ->
#           Accounts.UserToken.destroy!(token, authorize?: false)

#         _ ->
#           :ok
#       end
#     end

#     conn
#     |> clear_session()
#     |> redirect(to: return_to)
#   end
# end
