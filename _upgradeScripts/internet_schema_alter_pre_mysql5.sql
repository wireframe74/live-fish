[if not] show columns from customer like 'customer_type_domain_id';
[then] alter table customer add customer_type_domain_id int(11) after bio_blob_storage_id;
commit;

[if not] show columns from customer like 'discount_percentage';
[then] alter table customer add discount_percentage float after vat_number;
commit;

[if not] show columns from transaction_info like 'num_payment_attempts';
[then] alter table transaction_info add num_payment_attempts integer after last_page_accessed;
commit;

[if not] show columns from transaction_info like 'transaction_completed';
[then] alter table transaction_info add transaction_completed smallint after num_payment_attempts;
commit;

[if not] show columns from transaction_info like 'card_type';
[then] alter table transaction_info add card_type varchar(10) after transaction_completed;
commit;

[if not] show columns from customer like 'bio_blob_storage_id';
[then] alter table customer add bio_blob_storage_id integer after bio_id;
commit;

[if not] show columns from order_tracking like 'till_id';
[then] alter table order_tracking add till_id int(11) NOT NULL default 10 after order_tracking_type_domain_id;
commit;

[if not] show columns from address like 'contact_usage_domain_id';
[then] alter table address add contact_usage_domain_id int(11) NOT NULL default 7500 after contact;
commit;

[if not] show columns from list_class_hdr like 'quantity';
[then] alter table list_class_hdr add quantity int(11) NULL default NULL after object_id;
commit;

[if not] show columns from vendor_article like 'RRP';
[then] alter table vendor_article add RRP float NULL default NULL after preferred_vendor_article_id;
commit;

[if not] show columns from vendor_article_clsfn like 'override_short_description';
[then] alter table vendor_article_clsfn add override_short_description varchar(100) NULL default NULL after override_reorder_level;
commit;