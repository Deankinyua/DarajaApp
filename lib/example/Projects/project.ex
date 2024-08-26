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
  end
end
