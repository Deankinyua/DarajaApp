defmodule Example.Activation do
  use Ash.Domain

  domain do
    description """
    This Domain holds Resources related to the Brand Ambassadors.
    """
  end

  resources do
    resource Example.Activation.Promoter do
      # Define an interface for calling resource actions.
      # We use the Function when we executing code
      # <Function> <Action>
      define :create_promoter, action: :create
      define :list_promoters, action: :read
      define :update_promoter, action: :update
      define :destroy_promoter, action: :destroy
      define :get_promoter, args: [:id], action: :by_id
    end
  end
end
