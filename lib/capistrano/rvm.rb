load File.expand_path("../tasks/rvm.rake", __FILE__)

# all stage-based tasks are supported by default
Capistrano::DSL.stages.each do |stage|
  after stage, 'rvm:hook'
  after stage, 'rvm:check'
end
