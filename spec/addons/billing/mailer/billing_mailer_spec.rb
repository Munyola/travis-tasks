require 'spec_helper'

describe Travis::Addons::Billing::Mailer::BillingMailer do
  describe '#invoice_payment_succeeded' do
    subject(:mail) { described_class.invoice_payment_succeeded(recipients, subscription, owner, charge, event, invoice, cc_last_digits) }

    let(:recipients) { ['sergio@travis-ci.com'] }
    let(:subscription) {{}}
    let(:owner) {{}}
    let(:invoice) {{ 'pdf_url' => pdf_url}}
    let(:pdf_url) {  'http://invoices.travis-ci.dev/invoices/123'}
    let(:filename) { 'TP123.pdf' }
    let(:cc_last_digits) {{}}
    let(:charge) { nil}
    let(:event) { nil}

    before do
      stub_request(:get, pdf_url).to_return(status: 200, body: "% PDF", headers: {'Content-Disposition' => "attachment; filename=\"#{filename}\""})
    end

    it 'contains the right data' do
      expect(mail.to).to eq(recipients)
      expect(mail.from).to eq(['success@travis-ci.com'])
      expect(mail.subject).to eq('Travis CI: Your Invoice')

      expect(mail.attachments.size).to eq(1)

      attachment = mail.attachments.first

      # TODO: check if this really validates the attachment, since there is a number of things that could be wrong (encoding?)
      expect(attachment.content_type).to start_with('application/pdf')
      expect(attachment.filename).to eq(filename)
      expect(attachment.body.raw_source).to start_with('% PDF')
    end
  end
end
