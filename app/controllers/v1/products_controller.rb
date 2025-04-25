# frozen_string_literal: true


  module V1
    class ProductsController < ActionController::API
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      http_basic_authenticate_with name: "username", password: "passwd123"
      def index
        render json: @products = Product.all
      end

      def show
        render json: @product = Product.find(params[:id])
      end

    end

  end

