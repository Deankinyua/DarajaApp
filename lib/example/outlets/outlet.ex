defmodule Example.Outlet do
  use Ash.Domain

  domain do
    description """
    This Domain holds Resources related to the Outlets.
    """
  end

  resources do
    resource Example.Outlet.Region do
      # Define an interface for calling resource actions.
      define :create_region, action: :create
      define :list_regions, action: :read
      define :update_region, action: :update
      define :destroy_region, action: :destroy
      define :get_region, args: [:id], action: :by_id
    end

    resource Example.Outlet.Shop do
      # Define an interface for calling resource actions.
      define :create_outlet, action: :create
      define :list_outlets, action: :read
      define :update_outlet, action: :update
      define :destroy_outlet, action: :destroy
      define :get_outlet, args: [:id], action: :by_id
    end
  end
end
