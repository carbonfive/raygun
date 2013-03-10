require "spec_helper"

describe Raygun::Runner do
  let(:temporary_path) { Dir.mktmpdir }
  let(:application) { "zabulon-x" }
  let(:application_path) { File.expand_path(application, temporary_path) }

  subject { Raygun::Runner.new }

  before do
    subject.stub(destination_root: application_path)
  end

  def stub_except(thing, *excluded)
    thing_methods = thing.public_methods - Object.new.public_methods
    (thing_methods - excluded).each { |pm| thing.stub(pm) }
  end

  def application_pathname(path)
    Pathname.new(File.expand_path(path, application_path))
  end

  describe ".source_root" do
    it "points to the app_prototype directory" do
      Raygun::Runner.source_root.should == File.expand_path("../../../../app_prototype", __FILE__)
    end
  end

  describe "#zap" do
    before do
      subject.unstub(:destination_root)
      stub_except(subject, :zap, :destination_root=, :destination_root)
    end

    describe "after invocation" do
      before { subject.zap("/inflatable-underwear") }
      its(:destination_root) { should == "/inflatable-underwear" }
    end

    it "checks the target" do
      subject.should_receive(:check_target)
      subject.zap(temporary_path)
    end

    it "prints the plan" do
      subject.should_receive(:print_plan)
      subject.zap(temporary_path)
    end

    it "copies the prototype into place" do
      subject.should_receive(:copy_prototype)
      subject.zap(temporary_path)
    end

    it "renames the new application" do
      subject.should_receive(:rename_new_app)
      subject.zap(temporary_path)
    end

    it "updates the ruby version" do
      subject.should_receive(:update_ruby_version)
      subject.zap(temporary_path)
    end

    it "initializes git" do
      subject.should_receive(:initialize_git)
      subject.zap(temporary_path)
    end
    
    it "prints the next steps" do
      subject.should_receive(:print_next_steps)
      subject.zap(temporary_path)
    end
  end

  describe "#check_target" do
    before { subject.stub(destination_root: application_path) }

    context "when the target is empty" do
      it "makes the destination" do
        expect { subject.check_target }.to change { File.exists?(application_path) }
      end

      it "does not raise an exception" do
        expect do
          subject.check_target
        end.not_to raise_error
      end
    end

    context "when the target is a file" do
      before { FileUtils.touch(application_path) }

      it "raises an exception" do
        expect do
          subject.check_target
        end.to raise_error(Thor::Error)
      end
    end

    context "when the target has a file in it" do
      before do
        FileUtils.mkdir_p(application_path)
        FileUtils.touch(File.expand_path("critter", application_path))
      end

      it "raises an exception" do
        expect do
          subject.check_target
        end.to raise_error(Thor::Error)
      end
    end
  end

  describe "#print_plan" do
    it "prints the camelized name" do
      subject.should_receive(:say).with do |message|
        message.should include "ZabulonX"
      end
      subject.print_plan
    end

    it "prints the application path" do
      subject.should_receive(:say).with do |message|
        message.should include application_path
      end
      subject.print_plan
    end
  end

  describe "#copy_prototype" do
    before { subject.copy_prototype }

    it "copies some standard rails stuff" do
      application_pathname("config/application.rb").should exist
    end

    it "creates a guardfile" do
      application_pathname("Guardfile").should exist
    end
  end

  describe "#replace_in_destination" do
    let(:template_path) { application_pathname("what.txt") }

    before do
      FileUtils.mkdir_p(application_path)
      template_path.open("w+") { |template| template << "legitimacy" }
    end

    it "replaces a string in the path" do
      subject.replace_in_destination("legitimacy", "crazy-eyed whalers")
      template_path.read.should include "crazy-eyed whalers"
    end
  end

  describe "#rename_new_app" do
    let(:config_path) { application_pathname("config/application.rb") }

    before do
      FileUtils.mkdir_p(application_path)
      subject.copy_prototype
      subject.rename_new_app
    end

    it "writes the application name" do
      config_path.read.should include "module ZabulonX"
    end
  end

  describe "#update_ruby_version" do
    let(:rvmrc_path) { application_pathname(".rvmrc") }
    let(:gemfile_path) { application_pathname("Gemfile") }

    before do
      FileUtils.mkdir_p(application_path)
      subject.copy_prototype
      subject.stub(:current_version => "is-totally-innocent")
      subject.stub(:current_patch => "hey-where-are-my-pants")
      subject.update_ruby_version
    end

    it "updates the ruby version in the rvmrc" do
      rvmrc_path.read.should include "rvm use ruby-hey-where-are-my-pants"
    end

    it "updates the ruby version in the gemfile" do
      gemfile_path.read.should include %(ruby 'is-totally-innocent')
    end
  end

  describe "#initialize_git" do
    before do
      FileUtils.mkdir_p(application_path)
      application_pathname("barrel").open("w+") { |barrel| barrel << "monkeys" }
      subject.initialize_git
    end

    it "initializes a new git directory" do
      application_pathname(".git/config").should exist
    end

    it "checks in the file" do
      application_pathname(".git/index").should exist
    end

    it "commits the file" do
      application_pathname(".git/logs").should exist
    end
  end

  describe "#print_next_steps" do
    let(:says) { [] }
    let(:accreted_message) { says.join("") }

    before { subject.stub(:say) { |message| says << message } }

    it "tells the user where the app is located" do
      subject.print_next_steps
      accreted_message.should =~ /cd #{subject.destination_root}/
    end
  end

  describe "names" do
    context "with a single word path" do
      let(:application) { "drugboat" }
      its(:camel_name) { should == "Drugboat" }
      its(:dash_name) { should == "drugboat" }
      its(:snake_name) { should == "drugboat" }
      its(:title_name) { should == "Drugboat" }
    end

    context "with a two-word path" do
      let(:application) { "unexplained-twitching" }
      its(:camel_name) { should == "UnexplainedTwitching" }
      its(:dash_name) { should == "unexplained-twitching" }
      its(:snake_name) { should == "unexplained_twitching" }
      its(:title_name) { should == "Unexplained Twitching" }
    end
  end
end
