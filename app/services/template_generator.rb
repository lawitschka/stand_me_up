module TemplateGenerator
  class << self
    def generate(team_id)
      team = Clubhouse.team(team_id)

      workflow = Clubhouse.workflows.
        select {|wf| wf[:team_id] == team_id }[0][:states].
        select { |s| %w(started done).include?(s[:type]) }

      workflow_state_ids = workflow.map {|e| e[:id]}

      stories = Clubhouse.team_stories(team_id).
        select { |s| workflow_state_ids.include?(s[:workflow_state_id])}.
        group_by{ |e| e[:workflow_state_id]}
    end
  end
end
