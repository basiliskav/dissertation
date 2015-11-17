require 'spec_helper'

describe GroupDocs::Signature::Field do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('signature_fields_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!({}, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      lambda { described_class.get!(:id => "dsaoij3928ukr03") }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Field objects' do
      fields = described_class.get!
      fields.should be_an(Array)
      fields.each do |field|
        field.should be_a(GroupDocs::Signature::Field)
      end
    end
  end

  it { should have_accessor(:id)                }
  it { should have_accessor(:templateId)        }
  it { should have_accessor(:recipientId)       }
  it { should have_accessor(:signatureFieldId)  }
  it { should have_accessor(:graphSizeW)        }
  it { should have_accessor(:graphSizeW)        }
  it { should have_accessor(:graphSizeH)        }
  it { should have_accessor(:graphSizeH)        }
  it { should have_accessor(:getDataFrom)       }
  it { should have_accessor(:regularExpression) }
  it { should have_accessor(:fontName)          }
  it { should have_accessor(:fontColor)         }
  it { should have_accessor(:fontSize)          }
  it { should have_accessor(:fontBold)          }
  it { should have_accessor(:fontItalic)        }
  it { should have_accessor(:fontUnderline)     }
  it { should have_accessor(:isSystem)          }
  it { should have_accessor(:fieldType)         }
  it { should have_accessor(:acceptableValues)  }
  it { should have_accessor(:defaultValue)      }
  it { should have_accessor(:tooltip)           }
  it { should have_accessor(:input)             }
  it { should have_accessor(:order)             }
  it { should have_accessor(:textRows)          }
  it { should have_accessor(:textColumns)       }
  it { should have_accessor(:location)          }
  it { should have_accessor(:locations)         }

  it { should alias_accessor(:template_id,        :templateId)        }
  it { should alias_accessor(:recipient_id,       :recipientId)       }
  it { should alias_accessor(:signature_field_id, :signatureFieldId)  }
  it { should alias_accessor(:graph_size_w,       :graphSizeW)        }
  it { should alias_accessor(:graph_size_width,   :graphSizeW)        }
  it { should alias_accessor(:graph_size_h,       :graphSizeH)        }
  it { should alias_accessor(:graph_size_height,  :graphSizeH)        }
  it { should alias_accessor(:get_data_from,      :getDataFrom)       }
  it { should alias_accessor(:regular_expression, :regularExpression) }
  it { should alias_accessor(:font_name,          :fontName)          }
  it { should alias_accessor(:font_color,         :fontColor)         }
  it { should alias_accessor(:font_size,          :fontSize)          }
  it { should alias_accessor(:font_bold,          :fontBold)          }
  it { should alias_accessor(:font_italic,        :fontItalic)        }
  it { should alias_accessor(:font_underline,     :fontUnderline)     }
  it { should alias_accessor(:is_system,          :isSystem)          }
  it { should alias_accessor(:acceptable_values,  :acceptableValues)  }
  it { should alias_accessor(:default_value,      :defaultValue)      }
  it { should alias_accessor(:text_rows,          :textRows)          }
  it { should alias_accessor(:text_columns,       :textColumns)       }

  describe '#location=' do
    it 'converts location to GroupDocs::Signature::Field::Location object if hash is passed' do
      subject.location = { :id => 'location1' }
      subject.location.should be_a(GroupDocs::Signature::Field::Location)
    end

    it 'saves each location if it is GroupDocs::Signature::Field::Location object' do
      location = GroupDocs::Signature::Field::Location.new(:id => 'location')
      subject.location = location
      subject.location.should == location
    end

    it 'appends location to locations if it is not empty' do
      location1 = GroupDocs::Signature::Field::Location.new(:id => 'location1')
      location2 = GroupDocs::Signature::Field::Location.new(:id => 'location2')
      subject.locations = [location1]
      subject.location = location2
      subject.locations.should == [location1, location2]
    end

    it 'creates locations if it is empty' do
      subject.locations = nil
      location = GroupDocs::Signature::Field::Location.new(:id => 'location')
      subject.location = location
      subject.locations.should == [location]
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.location = nil
      end.should_not change(subject, :location)
    end
  end

  describe '#locations=' do
    it 'converts each location to GroupDocs::Signature::Field::Location object if hash is passed' do
      subject.locations = [{ :id => 'location1' }]
      locations = subject.locations
      locations.should be_an(Array)
      locations.each do |location|
        location.should be_a(GroupDocs::Signature::Field::Location)
      end
    end

    it 'saves each location if it is GroupDocs::Signature::Field::Location object' do
      location1 = GroupDocs::Signature::Field::Location.new(:id => 'location1')
      location2 = GroupDocs::Signature::Field::Location.new(:id => 'location2')
      subject.locations = [location1, location2]
      subject.locations.should include(location1)
      subject.locations.should include(location2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.locations = nil
      end.should_not change(subject, :locations)
    end
  end

  describe '#field_type=' do
    it 'converts field type in machine-readable format if symbol is passed' do
      subject.field_type = :multiline
      subject.instance_variable_get(:@fieldType).should == 3
    end

    it 'saves field type as is if not a symbol is passed' do
      subject.field_type = 3
      subject.instance_variable_get(:@fieldType).should == 3
    end

    it 'is aliased to #type=' do
      subject.should have_alias(:type=, :field_type=)
    end
  end

  describe '#field_type' do
    it 'returns field type in human-readable format' do
      subject.field_type = :multiline
      subject.field_type.should == :multiline
    end

    it 'is aliased to #type' do
      subject.should have_alias(:type, :field_type)
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('signature_field_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!
    end

    it 'updates identifier of field' do
      lambda do
        subject.create!
      end.should change(subject, :id)
    end
  end

  describe '#modify!' do
    before(:each) do
      mock_api_server(load_json('signature_field_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.modify!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.modify!
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "field": null }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
