module TemplateGenerator
  class << self
    def generate(team_id)
      team = Clubhouse.team(team_id)

      states = Clubhouse.workflows.
        select { |wf| wf[:team_id] == team_id }[0][:states].
        select { |s| %w(started done).include?(s[:type]) }.
        sort_by { |s| -s[:position] }

      workflow_state_ids = states.map { |e| e[:id] }

      stories = Clubhouse.team_stories(team_id).
        select { |s| workflow_state_ids.include?(s[:workflow_state_id]) }

      stories = filter_completed_stories(
        stories,
        states.select { |s| s[:type] == 'done' }.map { |e| e[:id] }
      )

      stories = stories.group_by{ |e| e[:workflow_state_id] }

      render_markdown({
        team_name: team[:name],
        states: states,
        stories: stories,
      })
    end

    def filter_completed_stories(stories, completed_state_ids)
      stories.select do |story|
        !completed_state_ids.include?(story[:workflow_state_id]) ||
        (
          !!story[:completed_at] &&
          Date.parse(story[:completed_at]) >= last_standup_date
        )
      end
    end

    def last_standup_date
      last_standup = Date.today

      loop do
        last_standup -= 1.day
        break unless last_standup.saturday? ||
                     last_standup.sunday? ||
                     PublicHoliday.instance.is_public_holiday?(last_standup)
      end

      last_standup
    end

    def render_markdown(vars)
      MarkdownRenderer.new('daily-notes').render(vars)
    end
  end
end
