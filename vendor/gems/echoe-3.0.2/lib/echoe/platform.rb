
### Platform check regexes

module Platform
  def self.windows?
    @windows ||= RUBY_PLATFORM =~ /djgpp|(cyg|ms|bcc)win|mingw/
    !@windows.nil?
  end

  def self.gcc?
    @gcc ||= RUBY_PLATFORM =~ /mingw/
    !@gcc.nil?
  end

  def self.msvc?
    @msvc ||= RUBY_PLATFORM =~ /mswin/
    !@msvc.nil?
  end
  
  def self.java?
    @java ||= RUBY_PLATFORM =~ /java/
    !@java.nil?
  end
  
  def self.rake
    windows? ? 'rake.bat' : 'rake'
  end
  
  def self.make
    msvc? ? 'nmake' : 'make'
  end
end

### Overrides for cross packaging, which Rubygems 0.9.5 doesn't do

module Gem
  class Specification

    alias :old_validate :validate    
           
    PLATFORM_CROSS_TARGETS = ["aix", "cygwin", "darwin", "freebsd", "hpux", "java", "linux", "mingw", "mswin", "netbsdelf", "openbsd", "solaris", "_platform", "jruby"]
    
    def validate
      begin
        old_validate
      rescue Gem::InvalidSpecificationException
        if platform =~ /(#{PLATFORM_CROSS_TARGETS.join("|")})/i
          true
        else
          raise Gem::InvalidSpecificationException, "Unknown package target \"#{platform}\"."
        end
      end
    end
    
  end
end

### Some runtime Echoe hacks

$platform = "ruby" # or Gem::PLATFORM::RUBY maybe

def reset_target target #:nodoc:
  $platform = target
  Object.send(:remove_const, "RUBY_PLATFORM")
  Object.send(:const_set, "RUBY_PLATFORM", target)
end

if target = ARGV.detect do |arg| 
  # Hack to get the platform set before the Rakefile evaluates
    Gem::Specification::PLATFORM_CROSS_TARGETS.include? arg
  end
  reset_target target
end

