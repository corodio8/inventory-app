require "spec_helper"

describe ComputersController do
  describe "routing" do

    it "routes to #index" do
      get("/computers").should route_to("computers#index")
    end

    it "routes to #new" do
      get("/computers/new").should route_to("computers#new")
    end

    it "routes to #show" do
      get("/computers/1").should route_to("computers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/computers/1/edit").should route_to("computers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/computers").should route_to("computers#create")
    end

    it "routes to #update" do
      put("/computers/1").should route_to("computers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/computers/1").should route_to("computers#destroy", :id => "1")
    end

  end
end
