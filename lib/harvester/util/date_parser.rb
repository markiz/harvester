# encoding: utf-8
#
# XXX: Passing :context => :past option to chronic parser
#      doesn't help much.
#
# 1.9.3p327 :007 > Chronic.parse('15 Jan 2010 13:59', :context => :past)
# 2010-01-14 13:59:00 +0300
# see also 1 year old bug: https://github.com/mojombo/chronic/issues/60
module Harvester
  module DateParser
    class Default
      def call(string)
        string = prepare_time_string(string)
        result = parse_timestamp(string) || parse_with_chronic(string) || parse_with_stdlib(string)
        if result && result.year > Time.now.year
          result = Time.mktime(Time.now.year, result.month, result.day, result.hour, result.min, result.sec)
        end
        result
      end
      alias_method :parse, :call

      def parse_timestamp(string)
        # check that string is numeric and is between 1990 and 2030
        if string =~ /\A\d+\z/ && string.to_i >= 631152000 && string.to_i <= 1893456000
          Time.at(string.to_i)
        end
      end

      def parse_with_chronic(string)
        Chronic18n.parse(string, locale)
      rescue
        nil
      end

      def parse_with_stdlib(string)
        Time.parse(string)
      rescue
        nil
      end

      def prepare_time_string(string)
        string = string.to_s
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

    class Ru < Default
      def prepare_time_string(string)
        super.sub(/(\d+)\.(\d+)\.(\d+)/, '\\2/\\1/\\3').
              gsub(/пн|вт|ср|чт|пт|сб|вс|понедельник|вторник|среда|четверг|пятница|суббота|воскресенье/, '')
      end

      def locale
        :ru
      end
    end

    class Kz < Ru
      def locale
        :kz
      end
    end

    class <<self
      def call(string, locale = :default)
        require 'chronic18n'
        parser_for_locale(locale).new.call(string)
      end
      alias_method :parse, :call

      def parser_for_locale(locale)
        const_get(locale.to_s.capitalize)
      rescue NameError
        Default
      end
    end
  end
end
