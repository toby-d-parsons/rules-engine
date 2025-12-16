class Api::V1::RulesController < Api::V1Controller
  def index
    render json: Rule.all
  end

  def create
    rule = Rule.new(rule_params)

    if rule.save
      render json: rule,
             status: :created,
             location: api_v1_rule_url(rule)
    else
      render json: rule.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
    def rule_params
      params.require(:rule).permit(:field, :operator, :value, :name)
    end
end
