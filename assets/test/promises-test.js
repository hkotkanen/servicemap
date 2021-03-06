(function() {
  var Q, asserters, baseUrl, browseButtonSelector, browser, chai, chaiAsPromised, delay, errorDelay, pageTitle, pollFreq, searchButton, searchFieldPath, searchResultPath, serviceTreeItemSelector, should, typeaheadResultPath, wd;

  Q = require('q');

  chai = require('chai');

  chaiAsPromised = require('chai-as-promised');

  chai.use(chaiAsPromised);

  should = chai.should();

  wd = void 0;

  browser = void 0;

  asserters = void 0;

  delay = 20000;

  errorDelay = 1000;

  pollFreq = 100;

  baseUrl = 'http://localhost:9001';

  pageTitle = 'Pääkaupunkiseudun palvelukartta';

  serviceTreeItemSelector = '#service-tree-container > ul > li';

  browseButtonSelector = '#browse-region';

  searchResultPath = '#navigation-contents li';

  searchButton = '#search-region > div > form > span.action-button.search-button > span';

  searchFieldPath = '#search-region > div > form > span:nth-of-type(1) > input';

  typeaheadResultPath = '#search-region span.twitter-typeahead span.tt-suggestions';

  describe('Browser test', function() {
    before(function() {
      wd = this.wd;
      chaiAsPromised.transferPromiseness = wd.transferPromiseness;
      browser = this.browser;
      return asserters = wd.asserters;
    });
    describe('Test navigation widget', function() {
      it('Title should become "Pääkaupunkiseudun palvelukartta"', function(done) {
        return browser.get(baseUrl).title().should.become(pageTitle).should.notify(done);
      });
      it('Should contain button "Selaa palveluita"', function(done) {
        return browser.waitForElementByCss(browseButtonSelector, delay, pollFreq).click().should.be.fulfilled.should.notify(done);
      });
      it('Should contain list item "Terveys"', function(done) {
        return browser.waitForElementByCss(serviceTreeItemSelector, asserters.textInclude('Terveys'), delay, pollFreq).should.be.fulfilled.should.notify(done);
      });
      return it('Should not contain list item "Sairaus"', function(done) {
        return browser.waitForElementByCss(serviceTreeItemSelector, asserters.textInclude('Sairaus'), errorDelay, pollFreq).should.be.rejected.should.notify(done);
      });
    });
    describe('Test look ahead', function() {
      it('Title should become "Pääkaupunkiseudun palvelukartta"', function(done) {
        return browser.get(baseUrl).title().should.become(pageTitle).should.notify(done);
      });
      return it('Should find item "Kallion kirjasto"', function(done) {
        var searchText;
        searchText = 'kallion kirjasto';
        return browser.waitForElementByCss(searchFieldPath, delay, pollFreq).click().type(searchText).waitForElementByCss(typeaheadResultPath, asserters.textInclude("Kallion kirjasto"), delay, pollFreq).should.be.fulfilled.should.notify(done);
      });
    });
    return describe('Test search', function() {
      it('Title should become "Pääkaupunkiseudun palvelukartta"', function(done) {
        return browser.get(baseUrl).title().should.become(pageTitle).should.notify(done);
      });
      it('Should manage to input search text', function(done) {
        var searchText;
        searchText = 'kallion kirjasto';
        return browser.waitForElementByCss(searchFieldPath, delay, pollFreq).click().type(searchText).should.be.fulfilled.should.notify(done);
      });
      it('Should manage to click search button', function(done) {
        return browser.waitForElementByCss(searchButton, delay, pollFreq).click().should.be.fulfilled.should.notify(done);
      });
      it('Should find item "Kallion kirjasto"', function(done) {
        return browser.waitForElementByCss(searchResultPath, asserters.textInclude("Kallion kirjasto"), delay, pollFreq).should.be.fulfilled.should.notify(done);
      });
      return it('Should not find item "Kallio2n kirjasto"', function(done) {
        return browser.waitForElementByCss(searchResultPath, asserters.textInclude("Kallio2n kirjasto"), errorDelay, pollFreq).should.be.rejected.should.notify(done);
      });
    });
  });

}).call(this);

//# sourceMappingURL=promises-test.js.map
