require "spec_helper"

class Posts < RDF::Vocabulary('http://example.org/posts/predicates/')
  property :rating
end

describe "serialized_property" do

  before :all do
    require 'rdf/ntriples'
    class ::Post < Spira::Base
      type RDF::URI.new('http://rdfs.org/sioc/types#Post')
      configure :base_uri => "http://example.org/posts"
      property :comments,  :predicate => SIOC.has_reply, :serialize => true
      property :title,    :predicate => DC.title
      property :body,     :predicate => SIOC.content
    end
  end

  context "Post class basics" do
    before :each do
      Spira.repository = RDF::Repository.new
      @post = Post.new
    end

    it "should have a comments method" do
      @post.should respond_to :comments
    end

    it "should having a comments= method" do
      @post.should respond_to :comments=
    end

    it "should report that bodies are not a reflection" do
      Post.reflect_on_association(:comments).should be_nil
    end

    it "should allow setting and saving elements" do
      @post.comments = ['test1', 'test2']
      @post.save!
      @post.reload
      @post.comments.should == ['test1', 'test2']
    end
    
    it "should allow appending elements" do
      @post.comments << 'test1'
      @post.save!
      @post.reload
      @post.comments.should == ['test1']
    end
  end
end
