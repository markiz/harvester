# encoding: utf-8
module Harvester
  module DateParser
    class Default
      class <<self
        def parse(string)
          result = Chronic18n.parse(prepare_time_string(string.to_s), locale)
          if result && result.year > Time.now.year
            result = Time.mktime(Time.now.year, result.month, result.day, result.hour, result.min, result.sec)
          end
          result
        end

        def prepare_time_string(string)
          string = string.respond_to?(:mb_chars) ? string.mb_chars.downcase : string.downcase
          string.gsub(/[^[:alnum:],.:\-\s\/]/, ' ').
                 gsub(/\s[\-]\s/, ' ').
                 gsub(/\s+/, ' ').
                 gsub(/mon|tue|wed|thu|fri|sat|sun|monday|tuesday|wednesday|thursday|friday|saturday|sunday/, '').
                 strip.
                 to_s
        end

        def locale
          :en
        end
      end
    end

    class Ru < Default
      class <<self
        def prepare_time_string(string)
          super.sub(/(\d+)\.(\d+)\.(\d+)/, '\\2/\\1/\\3').
                gsub(/пн|вт|ср|чт|пт|сб|вс|понедельник|вторник|среда|четверг|пятница|суббота|воскресенье/, '')
        end

        def locale
          :ru
        end
      end
    end

    class <<self
      def parse(string, locale = :default)
        require 'chronic18n'
        parser_for_locale(locale).parse(string)
      end

      def parser_for_locale(locale)
        const_get(locale.to_s.capitalize)
      rescue NameError
        Default
      end
    end
  end
end
