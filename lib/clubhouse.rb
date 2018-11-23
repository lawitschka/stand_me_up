module Clubhouse
  class << self
    # FIXME: Read from secret store
    def client
      ClubhouseRuby::Clubhouse.new(ENV['CLUBHOUSE_TOKEN'])
    end

    def teams
      wrap_response client.teams.list
    end

    def team(id)
      wrap_response client.teams(id).list
    end

    def team_stories(team_id)
      team = team(team_id)

      # FIXME: We are swallowing errors here from sub-requests
      team[:project_ids].map do |project_id|
        wrap_response client.projects(project_id).stories.list
      end.flatten
    end

    def workflows
      wrap_response client.workflows.list
    end

    def wrap_response(response)
      if response[:status] == "OK"
        content = response[:content]
        content.is_a?(Array) ? content.map(&:deep_symbolize_keys) : content.deep_symbolize_keys
      else
        nil
      end
    end
  end
end
