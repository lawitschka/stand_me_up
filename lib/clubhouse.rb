module Clubhouse
  # FIXME: Read from secret store
  def self.client
    ClubhouseRuby::Clubhouse.new('5bf7d1b4-204b-4a9f-852a-985bace6b079')
  end

  def self.teams
    response = client.teams.list

    if response[:status] == "OK"
      response[:content].map(&:symbolize_keys)
    else
      nil
    end
  end

  def self.team(id)
    response = client.teams(id).list

    if response[:status] == "OK"
      response[:content].symbolize_keys
    else
      nil
    end
  end

  def self.team_stories(team_id)
    team = team(team_id)

    team[:project_ids].map do |project_id|
      response = client.projects(project_id).stories.list

      if response[:status] == "OK"
        response[:content].symbolize_keys
      else
        nil
      end
    end.flatten
  end
end
