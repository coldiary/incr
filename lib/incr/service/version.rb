require 'sem_version'

module Incr
  module Service
    class Version
      IDENTIFIER_PATTERN = /\A[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*\z/
      IDENTIFIER_COUNTER_PATTERN = /\A(.+?)(?:\.([0-9]+))?\z/

      class Error < ArgumentError; end

      def self.increment_segment(version, segment, identifier = nil)
        incremented_version = version.clone

        case segment
        when 'major'
          incremented_version.major = version.major + 1
          incremented_version.minor = 0
          incremented_version.patch = 0
          incremented_version.pre = nil
          incremented_version.metadata = nil
        when 'minor'
          incremented_version.minor = version.minor + 1
          incremented_version.patch = 0
          incremented_version.pre = nil
          incremented_version.metadata = nil
        when 'patch'
          incremented_version.patch = version.patch + 1
          incremented_version.pre = nil
          incremented_version.metadata = nil
        when 'prerelease'
          incremented_version.pre = increment_identifier(version.pre, identifier, 'pre-release')
          incremented_version.metadata = nil
        when 'build'
          incremented_version.metadata = increment_identifier(version.metadata, identifier, 'build')
        end

        incremented_version
      end

      def self.increment_identifier(current, requested, label)
        requested_base = normalize_identifier(requested) if requested
        current_base, current_number = split_identifier(current) if current

        if requested_base && current_base && requested_base != current_base
          raise Error, "version already contains #{label} identifier '#{current_base}'; requested '#{requested_base}'"
        end

        base = requested_base || current_base
        unless base
          raise Error, "a #{label} identifier is required when the version has no #{label} identifier"
        end

        number = current_number ? current_number + 1 : 0
        "#{base}.#{number}"
      end
      private_class_method :increment_identifier

      def self.normalize_identifier(identifier)
        unless identifier.is_a?(String) && identifier.match?(IDENTIFIER_PATTERN)
          raise Error, "invalid identifier '#{identifier}'"
        end

        split_identifier(identifier).first
      end
      private_class_method :normalize_identifier

      def self.split_identifier(identifier)
        match = identifier.match(IDENTIFIER_COUNTER_PATTERN)
        [match[1], match[2]&.to_i]
      end
      private_class_method :split_identifier
    end
  end
end
