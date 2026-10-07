require 'spec_helper'

require 'sem_version'

describe Incr::Service::Version do
  describe '.increment_segment' do
    context 'with a SemVersion object' do
      let(:version) { SemVersion.new('1.2.4') }

      it 'should increment the major segment and reset the minor and patch segments' do
        expected = '2.0.0'
        result = Incr::Service::Version.increment_segment(version, 'major')

        expect(result.to_s).to eql(expected)
      end

      it 'should increment the minor segment and reset the patch segment' do
        expected = '1.3.0'
        result = Incr::Service::Version.increment_segment(version, 'minor')

        expect(result.to_s).to eql(expected)
      end

      it 'should increment the patch segment' do
        expected = '1.2.5'
        result = Incr::Service::Version.increment_segment(version, 'patch')

        expect(result.to_s).to eql(expected)
      end
    end

    context 'with prerelease versions' do
      it 'starts a prerelease with the requested identifier' do
        result = Incr::Service::Version.increment_segment(SemVersion.new('1.2.3'), 'prerelease', 'alpha')

        expect(result.to_s).to eql('1.2.3-alpha.0')
      end

      it 'increments an existing prerelease and clears build metadata' do
        result = Incr::Service::Version.increment_segment(SemVersion.new('1.2.3-alpha.1+ci.4'), 'prerelease')

        expect(result.to_s).to eql('1.2.3-alpha.2')
      end

      it 'rejects a conflicting prerelease identifier' do
        expect {
          Incr::Service::Version.increment_segment(SemVersion.new('1.2.3-beta.1'), 'prerelease', 'alpha')
        }.to raise_error(Incr::Service::Version::Error, /already contains/)
      end

      it 'rejects an invalid prerelease identifier' do
        expect {
          Incr::Service::Version.increment_segment(SemVersion.new('1.2.3'), 'prerelease', 'alpha+ci')
        }.to raise_error(Incr::Service::Version::Error, /invalid identifier/)
      end
    end

    context 'with build versions' do
      it 'starts build metadata with the requested identifier' do
        result = Incr::Service::Version.increment_segment(SemVersion.new('1.2.3'), 'build', 'ci')

        expect(result.to_s).to eql('1.2.3+ci.0')
      end

      it 'increments existing build metadata and preserves prerelease metadata' do
        result = Incr::Service::Version.increment_segment(SemVersion.new('1.2.3-alpha.1+ci.4'), 'build')

        expect(result.to_s).to eql('1.2.3-alpha.1+ci.5')
      end

      it 'rejects a conflicting build identifier' do
        expect {
          Incr::Service::Version.increment_segment(SemVersion.new('1.2.3+ci.1'), 'build', 'release')
        }.to raise_error(Incr::Service::Version::Error, /already contains/)
      end

      it 'rejects an invalid build identifier' do
        expect {
          Incr::Service::Version.increment_segment(SemVersion.new('1.2.3'), 'build', 'ci+1')
        }.to raise_error(Incr::Service::Version::Error, /invalid identifier/)
      end
    end

    context 'with a version string' do
      let(:version) { '1.0.0' }

      it 'should throw an error' do
        expect {
          Incr::Service::Version.increment_segment(version, 'patch')
        }.to raise_error(NoMethodError)
      end
    end

    context 'with an unknown segment' do
      let(:version) { SemVersion.new('1.0.0') }

      it 'should not do anything' do
        expected = '1.0.0'
        result = Incr::Service::Version.increment_segment(version, 'foobar')

        expect(result.to_s).to eql(expected)
      end
    end
  end
end
