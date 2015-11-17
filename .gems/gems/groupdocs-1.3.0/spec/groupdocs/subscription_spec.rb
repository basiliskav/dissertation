require 'spec_helper'

describe GroupDocs::Subscription do

  it_behaves_like GroupDocs::Api::Entity

  describe '.current!' do
    before(:each) do
      mock_api_server(load_json('subscription_plan_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.current!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Subscription object' do
      described_class.current!.should be_a(GroupDocs::Subscription)
    end
  end

  describe '.list!' do
    before(:each) do
      mock_api_server(load_json('subscription_plans_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.list!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Subscription objects' do
      plans = described_class.list!
      plans.should be_an(Array)
      plans.each do |plan|
        plan.should be_a(GroupDocs::Subscription)
      end
    end
  end

  it { should have_accessor(:Id)            }
  it { should have_accessor(:Name)          }
  it { should have_accessor(:PricingPlanId) }
  it { should have_accessor(:Price)         }
  it { should have_accessor(:CurrencyCode)  }

  it { should alias_accessor(:id, :Id)                         }
  it { should alias_accessor(:name, :Name)                     }
  it { should alias_accessor(:pricing_plan_id, :PricingPlanId) }
  it { should alias_accessor(:price, :Price)                   }
  it { should alias_accessor(:currency_code, :CurrencyCode)    }

  it { should have_alias(:ref_id=, :id=) }

  GroupDocs::Subscription::LIMITS.each do |snake, camel|
    it { should have_accessor(camel) }

    # reader is overwritten
    it { should have_alias(:"#{snake}=", :"#{camel}=") }

    describe "##{snake}" do
      it 'converts hash to GroupDocs::Subscription::Limit object' do
        subject.send(:"#{snake}=", { :min => 2, :max => 3, :description => 'Description' })
        limit = subject.send(snake)
        limit.should be_a(GroupDocs::Subscription::Limit)
        limit.min.should         == 2
        limit.max.should         == 3
        limit.description.should == 'Description'
      end
    end
  end
end
