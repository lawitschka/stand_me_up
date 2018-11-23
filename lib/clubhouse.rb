module Clubhouse
  class << self
    # FIXME: Read from secret store
    def client
      ClubhouseRuby::Clubhouse.new('5bf7d1b4-204b-4a9f-852a-985bace6b079')
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
      response = client.workflows.list

      wrap_response response[:content]
    end

    def wrap_response(response)
      if response[:status] == "OK"
        content = response[:content]
        content.respond_to?(:each) ? content.map(&:symbolize_keys) : content.symbolize_keys
      else
        nil
      end
    end
  end
end
