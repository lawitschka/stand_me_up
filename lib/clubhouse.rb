module Clubhouse
  class << self
    # FIXME: Read from secret store
    def token
      @token ||= ENV['CLUBHOUSE_TOKEN']
    end

    def client
      ClubhouseRuby::Clubhouse.new(token)
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
      if response[:status] == "OK"
        content = response[:state]
        content.respond_to?(:each) ? content.map(&:deep_symbolize_keys) : content.deep_symbolize_keys
      else
        nil
      end
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
