Capistrano::DSL.stages.each do |stage|
  after stage, 'rvm:hook'
  after stage, 'rvm:check'
end
