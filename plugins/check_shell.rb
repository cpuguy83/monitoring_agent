module Maxwell
  module Agent
    module Plugin
      class CheckShell
        include Maxwell::Agent::Probe

        def perform(*args)
          cmd = args.shift
          args = args.join(' ')
          system("#{cmd} #{args}")
        end
      end
    end
  end
end
