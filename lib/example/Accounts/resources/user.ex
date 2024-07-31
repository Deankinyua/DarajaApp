defmodule Example.Accounts.User do
  use Ash.Resource,
    domain: Example.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  resource do
    description """
    Represents the User of the DarajaPlus system.
    """
  end

  postgres do
    table "users"
    repo Example.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true

    attribute :name, :string do
      allow_nil? false
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  authentication do
    domain Example.Accounts

    strategies do
      password :password do
        identity_field(:email)
        sign_in_tokens_enabled?(true)
        confirmation_required?(false)
        # A list of additional fields to be accepted in the register action.
        register_action_accept([:name])
      end
    end

    tokens do
      enabled?(true)
      token_resource(Example.Accounts.Token)
      signing_secret(Example.Accounts.Secrets)
      store_all_tokens?(true)
      require_token_presence_for_authentication?(true)
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  validations do
    validate match(:email, ~r/^[^\s]+@[^\s]+$/), message: "must have the @ sign and no spaces"
  end

  actions do
    read :by_email do
      # This action has one argument :email of type :ci_string
      argument :email, :ci_string, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:email` given in the argument
      # against the `email` of each element in the resource
      filter expr(email == ^arg(:email))
    end
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
