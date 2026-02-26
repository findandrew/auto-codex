json.extract! project, :id, :name, :summary, :status, :created_at, :updated_at
json.url project_url(project, format: :json)
