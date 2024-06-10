This is a test application developed to test the use of wolfSSL within the pledge enrollment, mainly 
targeting the CMS signing function.
Isolated tests comparing OpenSSL and wolfSSL CMS signing can be found at the signing_tests/ folder,
and the modified pledge application is meant to be used with the product found at spec/files/product/00-D0-E5-F2-00-02/
usign the voucher.sh script.

Below is the README from the original repository.

# README

This is a test application that uses the Chariwt library to simulate a pledge
for the IETF ANIMA BRSKI protocol.

It performs a BRSKI enrollment.

Using it is described fully at: https://minerva.sandelman.ca/reach/
and also at: https://minerva.sandelman.ca/jokeshop/

For example, given files in the directory 00-D0-E5-02-00-0A/
one can run:

    rake reach:send_voucher_request PRODUCTID=00-D0-E5-02-00-0A JRC=https://fountain-test.sandelman.ca/

