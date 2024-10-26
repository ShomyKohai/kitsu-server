# frozen_string_literal: true

class DeprecationSubscriber < ActiveSupport::Subscriber
  class DisallowedDeprecation < StandardError; end

  module RubyWarningSubscriber
    def warn(message, category: nil, **_kwargs)
      if category == :deprecated
        ActiveSupport::Deprecation.warn(message)
      else
        super
      end
    end
  end

  attach_to :rails
  def deprecation(event)
    exception = DisallowedDeprecation.new(event.payload[:message])
    exception.set_backtrace(event.payload[:callstack].map(&:to_s))
    Sentry.capture_exception(exception, level: :warning)
  end
end

Warning[:deprecated] = true
Warning.extend(DeprecationSubscriber::RubyWarningSubscriber)
