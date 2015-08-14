require_relative 'isolation/pipe'
require_relative 'isolation/vacuum'

module Mutiny
  # This code originally based on Markus Schirp's implementation of Mutant::Isolation::Fork
  #  https://github.com/mbj/mutant/blob/master/lib/mutant/isolation.rb
  class Isolation
    # Runs the given block, isolating the global state so that changes cannot
    # leak out to the caller's runtime
    def self.call(&block)
      new(block).run_in_isolation
    rescue => exception
      raise Error, exception
    end

    attr_reader :isolated_code

    def initialize(isolated_code)
      @isolated_code = isolated_code
    end

    def run_in_isolation
      Pipe.with do |comms|
        begin
          pid = Process.fork { run_and_send_result_via(comms) }
          comms.receive # wait to receive the result form the child process
        ensure
          Process.waitpid(pid) if pid
        end
      end
    end

    def run_and_send_result_via(comms)
      Vacuum.silence($stderr) do
        result = isolated_code.call
        comms.send(result) # send the result to the parent process over the pipes
      end
    end

    Error = Class.new(RuntimeError)
  end
end
