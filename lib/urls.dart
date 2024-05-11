// var baseUrl = 'http://actinic.online:8081/';
var baseUrl = 'http://52.55.244.197:8081/';
// var baseUrl = 'http://10.0.2.2:8081/';

var baseRegisteredUrl = '${baseUrl}RegisterdUserApi/';

var registerTokenUrl = '${baseRegisteredUrl}User/Register';
var signInUrl = '${baseUrl}Api/Token/Create';

var registerUrl = '${baseUrl}odata/Customer';

// for individual product use with /product id

// For home screen components
var baseComponentUrl = '${baseRegisteredUrl}odata/Component/';

var fetchHomePageProductsUrl = '${baseComponentUrl}GetHomePageProducts';
var fetchHomePageNewProductsUrl = '${baseComponentUrl}GetHomePageNewProducts';
var fetchProductReviewsUrl = '${baseComponentUrl}GetProductReviews';
var fetchNewsUrl = '${baseComponentUrl}GetHomePageNews';
var fetchBlogUrl = '${baseComponentUrl}GetHomePageBlog';

// product
var baseProductUrl = '${baseRegisteredUrl}odata/Product/';

var fetchProductUrl = '${baseProductUrl}Get';
var setProductReview = '${baseProductUrl}ProductReviews';
var setProducthelpfulnessUrl = '${baseProductUrl}SetProductReviewHelpfulness';

//category
var fetchCategoryUrl = '${baseRegisteredUrl}odata/Category';

var fetchHomePageCategoryUrl = '${baseComponentUrl}GetHomePageCategory';

//catalog/category
var fetchProductByCategoryUrl = '${baseRegisteredUrl}odata/Catalog/Category';

//image
var imageForProductUrl = '${baseRegisteredUrl}odata/Picture';

// shoppingcart
var baseShoppingCartUrl = '${baseRegisteredUrl}odata/ShoppingCart/';

var fetchWishListUrl = '${baseShoppingCartUrl}Wishlist/';
var updateWishListUrl = '${baseShoppingCartUrl}UpdateWishlist';
var fetchCartListUrl = '${baseShoppingCartUrl}Cart';
var cartCountUrl = "${fetchCartListUrl}Count";
var updateItemCartUrl = '$baseShoppingCartUrl';
var deleteItemFromCartUrl = '${baseShoppingCartUrl}DeleteCartItem';
var clearCartUrl = '${baseShoppingCartUrl}ClearCart';
var startCheckoutUrl = '${baseShoppingCartUrl}StartCheckout';

// For adding products to cart and wishlist
var actionCartUrl = '${baseRegisteredUrl}odata/ActionCart';

// For checkout
var baseCheckoutUrl = '${baseRegisteredUrl}odata/Checkout/';

var onePageCheckoutUrl = '${baseCheckoutUrl}OnePageCheckout';
var opcSaveBillingUrl = '${baseCheckoutUrl}OpcSaveBilling';
var opcSaveShippingUrl = '${baseCheckoutUrl}OpcSaveShipping';
var opcSaveShippingMethodUrl = '${baseCheckoutUrl}OpcSaveShippingMethod';
var opcSavePaymentMethodUrl = '${baseCheckoutUrl}OpcSavePaymentMethod';
var opcSavePaymentInfoUrl = '${baseCheckoutUrl}OpcSavePaymentInfo';
var opcConfirmOrderUrl = '${baseCheckoutUrl}OpcConfirmOrder';

// For search
var baseSearchUrl = '${baseRegisteredUrl}odata/Search/';

var searchProductUrl = '$baseSearchUrl';
var autoCompleteUrl = '${baseSearchUrl}SearchKeywordAutoComplete';

//  For orders
var baseOrderUrl = '${baseRegisteredUrl}odata/Order/';

var fetchOrdersUrl = '${baseOrderUrl}CustomerOrders';
var fetchOrderProductsUrl = '${baseOrderUrl}Details';

// For Customer Account
var baseCustomerUrl = '${baseRegisteredUrl}odata/CustomerAccount/';

// var customerUrl = '${baseUrl}odata/Customer';
// var customerAddress
var customerUrl = '${baseCustomerUrl}Info';
var customerAddressesUrl = '${baseCustomerUrl}Addresses/';

var customerAddAddressUrl = '${baseCustomerUrl}AddressAdd';
var customerEditAddressUrl = '${baseCustomerUrl}AddressEdit';
var customerDeleteAddressUrl = '${baseCustomerUrl}AddressDelete';

var customerChangePasswordUrl = '${baseCustomerUrl}ChangePassword';

var customerPasswordRecoveryUrl = '${baseCustomerUrl}PasswordRecovery';
var customerPasswordRecoveryConfirmUrl =
    '${baseCustomerUrl}PasswordRecoveryConfirm';

var logoutCustomerUrl = '${baseCustomerUrl}Logout';

var countryUrl = '${baseRegisteredUrl}odata/Country';
var currencyUrl = '${baseRegisteredUrl}odata/Currency';
var shippingMethodsUrl = '${baseRegisteredUrl}odata/ShippingMethod';
var stateUrl = '${baseRegisteredUrl}odata/StateProvince';

// var countryUrl = '${baseUrl}odata/Country';
// var currencyUrl = '${baseUrl}odata/Currency';
// var shippingMethodsUrl = '${baseUrl}odata/ShippingMethod';
// var stateUrl = '${baseUrl}odata/StateProvince';

//commented
//var registerUrl = '${baseUrl}odata/Customer';
// var fetchAllProductUrl = '${baseUrl}odata/Product
// var fetchProductUrl = '${baseUrl}odata/Product';
// var fetchCategoryUrl = '${baseUrl}odata/Category';
// var fetchAllProductUrl = '$fetchProductUrl?top=5';
