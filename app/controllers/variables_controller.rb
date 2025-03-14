class VariablesController < ApplicationController
  def index
    # OpenFeature doesn't have an equivalent to this.
    user = DevCycle::User.new({ user_id: 'user_id_example' })
    @variables = DevCycleClient.all_variables(user)
  end
end
