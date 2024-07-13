defmodule Example.Accounts.User do
  use Ash.Resource,
    domain: Example.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  resource do
    description """
    Represents the user of a system.
    """
  end

  postgres do
    table "users"
    repo Example.Repo
  end

  # attributes do
  #   uuid_primary_key :id

  #   attribute :email, :ci_string do
  #     allow_nil? false
  #     public? true
  #   end

  #   attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  # end

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

  # authentication do
  #   strategies do
  #     password :password do
  #       identity_field :email
  #     end
  #   end

  #   tokens do
  #     enabled? true
  #     token_resource Example.Accounts.Token
  #     signing_secret Example.Accounts.Secrets
  #   end
  # end

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

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
