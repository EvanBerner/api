'use strict';

/**@ngInject*/
function ProductsAdminController(categories, clouds) {
  this.categories = categories;
  this.clouds = clouds;

  // TODO: Where are images stored and retrieved from?
  this.productImages = [
    'products/aws_ec2.png',
    'products/aws_rds.png',
    'products/aws_s3.png',
    // Filling in with the project images
    'projects/1.png',
    'projects/2.png',
    'projects/3.png',
    'projects/4.png',
    'projects/5.png',
    'projects/10.png',
    'projects/11.png',
    'projects/12.png',
    'projects/13.png',
    'projects/14.png',
    'projects/15.png',
    'projects/16.png',
    'projects/17.png',
    'projects/18.png',
  ];
}

ProductsAdminController.resolve = {
  /**@ngInject*/
  categories: function(ProductCategory) {
    return ProductCategory.query().$promise;
  },
  /**@ngInject*/
  clouds: function(Cloud) {
    return Cloud.query().$promise;
  }

};

module.exports = ProductsAdminController;
