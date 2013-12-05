require "spec_helper"

class Posts < RDF::Vocabulary('http://example.org/posts/predicates/')
  property :rating
end

describe "has_one" do

  before :all do
    require 'rdf/ntriples'
    class ::Post < Spira::Base
      type RDF::URI.new('http://rdfs.org/sioc/types#Post')
      configure :base_uri => "http://example.org/posts"
      has_one :comment,   :predicate => SIOC.has_reply, :type => :Comment
      property :title,    :predicate => DC.title
      property :body,     :predicate => SIOC.content
    end

    class ::Comment < Spira::Base
      type RDF::URI.new('http://rdfs.org/sioc/types#Comment')
      configure :base_uri => "http://example.org/comments"
      has_one :post,      :predicate => SIOC.reply_of, :type => :Post
      property :title,    :predicate => DC.title
      property :body,     :predicate => SIOC.content
    end
  end

  context "Comment class basics" do
    before :each do
      Spira.repository = RDF::Repository.new
      @post = Post.new
      @comment = Comment.new
      @comment_without_post = Comment.new
      @post.comment = @comment
      @comment.post = @post
    end

    it "should have a post method" do
      @comment.should respond_to :post
    end

    it "should having a post= method" do
      @comment.should respond_to :post=
    end

    it "should report that post is an association" do
      Comment.reflect_on_association(:post).should be_a AssociationReflection
    end

    it "should report that bodies are not a reflection" do
      Comment.reflect_on_association(:body).should be_nil
    end

    it "should return nil for comments with no post" do
      @comment_without_post.post.should be_nil
    end

    it "should allow setting and saving non-array elements" do
      @comment.title = 'test'
      @comment.title.should == 'test'
      @comment.save!
      @comment.title.should == 'test'
    end
    
    it "should not change if not changed" do
      @post.save; @comment.save
      @comment.post = @post
      @comment.post_changed?.should_not be_true
    end
  end
end
