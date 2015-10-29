load File.expand_path("../../tasks/rvm.rake", __FILE__)

# ONLY rvm:check is rvm supported by default
with_rvm 'rvm:check'
