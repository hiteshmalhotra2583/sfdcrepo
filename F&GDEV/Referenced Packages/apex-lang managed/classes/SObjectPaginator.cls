/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SObjectPaginator {
    global List<SObject> all {
        get;
    }
    global static Integer DEFAULT_PAGE_SIZE;
    global static Integer DEFAULT_SKIP_SIZE;
    global Boolean hasNext {
        get;
    }
    global Boolean hasPrevious {
        get;
    }
    global List<Integer> nextSkipPageNumbers {
        get;
    }
    global List<SObject> page {
        get;
    }
    global Integer pageCount {
        get;
    }
    global Integer pageEndPosition {
        get;
    }
    global Integer pageEndPositionDisplayFriendly {
        get;
    }
    global Integer pageNumber {
        get;
    }
    global Integer pageNumberDisplayFriendly {
        get;
    }
    global Integer pageSize;
    global Integer pageStartPosition {
        get;
    }
    global Integer pageStartPositionDisplayFriendly {
        get;
    }
    global List<Integer> previousSkipPageNumbers {
        get;
    }
    global Integer recordCount {
        get;
    }
    global Integer skipSize;
    global SObjectPaginator() {

    }
    global SObjectPaginator(al.SObjectPaginatorListener listener) {

    }
    global SObjectPaginator(Integer pageSize) {

    }
    global SObjectPaginator(Integer pageSize, al.SObjectPaginatorListener listener) {

    }
    global SObjectPaginator(Integer pageSize, Integer skipSize) {

    }
    global SObjectPaginator(Integer pageSize, Integer skipSize, al.SObjectPaginatorListener listener) {

    }
    global void addListener(al.SObjectPaginatorListener listener) {

    }
    global void firePageChangeEvent() {

    }
    global System.PageReference first() {
        return null;
    }
    global Integer getPageSize() {
        return null;
    }
    global System.PageReference last() {
        return null;
    }
    global System.PageReference next() {
        return null;
    }
    global System.PageReference previous() {
        return null;
    }
    global void setPageSize(Integer pageSize) {

    }
    global void setRecords(List<SObject> all) {

    }
    global void setSkipSize(Integer skipSize) {

    }
    global System.PageReference skipToPage(Integer pageNumber) {
        return null;
    }
}
