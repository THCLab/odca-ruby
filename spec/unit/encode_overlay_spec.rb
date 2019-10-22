require 'odca/overlays/encode_overlay'

RSpec.describe Odca::Overlays::EncodeOverlay do
  let(:overlay) do
    described_class.new
  end

  describe '#to_h' do
    context 'encode overlay has attributes' do
      before(:each) do
        overlay.add_attribute(
          described_class::EncodeAttribute.new(
            described_class::InputValidator.new(
              attr_name: 'attr_name', value: 'utf-8'
            ).call
          )
        )
        overlay.add_attribute(
          described_class::EncodeAttribute.new(
            described_class::InputValidator.new(
              attr_name: 'sec_attr', value: 'utf-8'
            ).call
          )
        )
      end

      it 'returns filled hash' do
        expect(overlay.to_h).to eql(
          default_encoding: 'utf-8',
          attr_encoding: {
            'attr_name' => 'utf-8',
            'sec_attr' => 'utf-8'
          }
        )
      end
    end
  end

  describe '#add_attribute' do
    before(:each) do
      overlay.add_attribute(attribute)
    end

    context 'when attribute is provided correctly' do
      let(:attribute) do
        described_class::EncodeAttribute.new(
          described_class::InputValidator.new(
            attr_name: 'attr', value: 'utf-8'
          ).call
        )
      end

      it 'adds attribute to attributes array' do
        expect(overlay.attributes)
          .to contain_exactly(attribute)
      end
    end

    context 'when attribute is nil' do
      let(:attribute) { nil }

      it 'ignores attribute' do
        expect(overlay.attributes).to be_empty
      end
    end
  end

  describe '#attr_values' do
    context 'when attributes are added' do
      before(:each) do
        overlay.add_attribute(
          described_class::EncodeAttribute.new(
            described_class::InputValidator.new(
              attr_name: 'attr_name', value: 'utf-8'
            ).call
          )
        )
        overlay.add_attribute(
          described_class::EncodeAttribute.new(
            described_class::InputValidator.new(
              attr_name: 'sec_attr', value: 'utf-8'
            ).call
          )
        )
      end

      it 'returns hash of attribute_names and encodings' do
        expect(overlay.__send__(:attr_values))
          .to include(
            'attr_name' => 'utf-8',
            'sec_attr' => 'utf-8'
          )
      end
    end
  end

  describe described_class::InputValidator do
    describe '#call' do
      let(:validator) do
        described_class.new(attr_name: 'attr_name', value: value)
      end

      context 'record is filled' do
        let(:value) { 'utf-8' }

        it 'sets input as value' do
          expect(validator.call).to include(
            attr_name: 'attr_name',
            value: 'utf-8'
          )
        end
      end

      context 'record is empty' do
        let(:value) { '  ' }

        it 'sets value as null_value' do
          expect(validator.call).to include(
            attr_name: 'attr_name',
            value: be_a(Odca::NullValue)
          )
        end
      end
    end
  end
end
