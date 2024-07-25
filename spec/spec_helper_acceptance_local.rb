# frozen_string_literal: true

require 'puppet_litmus'
require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.before :suite do
    if os[:family].match?(%r{redhat}i)
      LitmusHelper.instance.run_shell('dnf -y install dnf-plugins-core')
      LitmusHelper.instance.run_shell('dnf config-manager --set-enabled powertools')
      LitmusHelper.instance.run_shell('dnf -y module switch-to ruby:3.1')
    end
  end
end
