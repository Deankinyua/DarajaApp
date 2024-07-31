defmodule Example.Accounts do
  use Ash.Domain

  resources do
    resource Example.Accounts.Token

    resource Example.Accounts.User do
      # Define an interface for calling resource actions.
      # We use the Function when we executing code
      # <Function> <Args> <Action>

      define :get_user, args: [:email], action: :by_email
    end
  end
end
