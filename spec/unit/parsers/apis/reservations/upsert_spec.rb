require 'rails_helper'

RSpec.describe Parsers::Apis::Reservations::Upsert do
# Named as Upsert because this parser is used for both Post and Update actions which are Upserting.
# We will not use api versioning as google engineering recommends to avoid it and version in another way.

  let(:parser) { described_class }
  let(:payload_data) { File.read('sample_data/payload_1.json')}
  let(:payload) { JSON.parse(payload_data) }

  context "when parsing a reservation json," do
    context "with payload type 1" do
      it "is parsed to a flat structure" do
        debugger
      end
    end
  end
end
