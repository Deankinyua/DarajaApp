defmodule Example.ProjectGeneral do
  use Ash.Domain

  domain do
    description """
    This Domain holds All the project id's and names
    and also holds the details for making the reporting template
    """
  end

  resources do
    resource Example.ProjectGeneral.Project do
      # Define an interface for calling resource actions.
      # We use the Function when we executing code
      # <Function> <Action>
      define :add_project, action: :create
      define :update_project, action: :update
    end

    # resource Example.ProjectGeneral.Label do
    #   # Define an interface for calling resource actions.
    #   # We use the Function when we executing code
    #   # <Function> <Action>
    #   define :add_label, action: :create
    #   define :update_label, action: :update
    # end
  end

  # new_project =
  # (Example.ProjectGeneral.Project
  # |> Ash.Changeset.for_create(:new, %{
  #   name: "Project Three"

  # }))

  #  Ash.DataLayer.create(Example.ProjectGeneral.Project, new_project)
end
