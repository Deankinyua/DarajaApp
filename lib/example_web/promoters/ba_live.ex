defmodule ExampleWeb.BaLive do
  use ExampleWeb, :live_view
  alias Example.Activation
  alias Example.Activation.Promoter

  def render(assigns) do
    ~H"""
    <h2>promoters</h2>
    <div>
      <div :for={promoter <- @promoters}>
        <div><%= promoter.name %></div>
        <div><%= if Map.get(promoter, :id_num), do: promoter.id_num, else: "" %></div>
        <button phx-click="delete_promoter" phx-value-promoter-id={promoter.id}>delete</button>
      </div>
    </div>
    <h2>Create promoter</h2>
    <.form :let={f} for={@create_form} phx-submit="create_promoter">
      <.input type="text" field={f[:name]} placeholder="input the promoter name" />
      <.input type="number" field={f[:id_num]} placeholder="input the promoter's ID number" />
      <.button type="submit">create</.button>
    </.form>
    <h2>Update promoter</h2>
    <.form :let={f} for={@update_form} phx-submit="update_promoter">
      <.label>promoter Name</.label>
      <.input type="select" field={f[:promoter_id]} options={@promoter_selector} />
      <.input type="number" field={f[:id_num]} placeholder="input your identification number" />
      <.button type="submit">Update</.button>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    promoters = Activation.list_promoters!()

    socket =
      assign(socket,
        promoters: promoters,
        promoter_selector: promoter_selector(promoters),
        create_form: AshPhoenix.Form.for_create(Promoter, :create) |> to_form(),
        update_form:
          AshPhoenix.Form.for_update(List.first(promoters, %Promoter{}), :update) |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("delete_promoter", %{"promoter-id" => promoter_id}, socket) do
    promoter_id |> Activation.get_promoter!() |> Activation.destroy_promoter!()
    promoters = Activation.list_promoters!()

    {:noreply,
     assign(socket, promoters: promoters, promoter_selector: promoter_selector(promoters))}
  end

  def handle_event("create_promoter", %{"form" => %{"name" => name, "id_num" => id_num}}, socket) do
    Activation.create_promoter(%{name: name, id_num: id_num})
    promoters = Activation.list_promoters!()

    {:noreply,
     assign(socket, promoters: promoters, promoter_selector: promoter_selector(promoters))}
  end

  def handle_event("update_promoter", %{"form" => form_params}, socket) do
    %{"promoter_id" => promoter_id, "id_num" => id_num} = form_params
    promoter_id |> Activation.get_promoter!() |> Activation.update_promoter!(%{id_num: id_num})
    promoters = Activation.list_promoters!()

    {:noreply,
     assign(socket, promoters: promoters, promoter_selector: promoter_selector(promoters))}
  end

  defp promoter_selector(promoters) do
    for promoter <- promoters do
      {promoter.name, promoter.id}
    end
  end
end
