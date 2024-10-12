defmodule Example.Project do
  use Ash.Domain

  domain do
    description """
    This Domain holds Resources related to the Projects
    """
  end

  resources do
    resource Example.Project.Project1 do
      # Define an interface for calling resource actions.
      # We use the Function when we executing code
      # <Function> <Action>
      define :add_data, action: :create
      define :update_data, action: :update
      define :read_data, action: :read
    end

    resource Example.Project.Registry do
      # Define an interface for calling resource actions.
      # We use the Function when we executing code
      # <Function> <Action>
      define :register_ambassador, action: :create
      define :update_ambassador, action: :update
      # define :update_ambassador_day, action: :update
      define :read_registry, action: :read
      define :get_user_by_id, args: [:ambassador_id], action: :by_id
    end
  end
end
