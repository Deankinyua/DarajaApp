defmodule Example.Activation do
  use Ash.Domain

  domain do
    description """
    This Domain holds Resources related to the Brand Ambassadors.
    """
  end

  resources do
    resource Example.Activation.Ambassador do
      # Define an interface for calling resource actions.
      # We use the Function when we executing code
      # <Function> <Action>
      define :create_ambassador, action: :create
      define :list_ambassadors, action: :read
      define :update_ambassador, action: :update
      define :get_ambassador, args: [:ambassador_id], action: :by_id
      define :destroy_ambassador, action: :destroy
    end
  end
end
