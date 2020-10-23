SELECT (SELECT [sv].[ship_via] AS [service],
                                  (SELECT CASE WHEN [sa].[ShipperCode] = ' ' THEN 'TRADE' ELSE [sa].[ShipperCode] END AS [shipper],                          
                                        'CUSTOM' AS [packaging],
                        CASE WHEN DATEPART(WEEKDAY,GETDATE()) = 1 
                        THEN CONVERT(VARCHAR,GETDATE() + 1,101) WHEN DATEPART(WEEKDAY,GETDATE()) = 7 
                        THEN CONVERT(VARCHAR,GETDATE() + 2,101) 
                        ELSE CONVERT(VARCHAR,GETDATE(),101) 
                        END AS [shipdate], 
                        ISNULL([orm].[ship_to_name],'') AS [consignee/company], 
                        ISNULL([orm].[customer_name],'') AS [consignee/contact], 
                        ISNULL([orm].[ship_to_addr1],'') AS [consignee/address1], 
                        ISNULL([orm].[ship_to_addr2],'') AS [consignee/address2], 
                        ISNULL([orm].[ship_to_addr3],'') AS [consignee/address3], 
                        ISNULL([orm].[ship_to_city],'') AS [consignee/city], 
                        ISNULL([orm].[ship_to_zip],'') AS [consignee/postalCode], 
                        ISNULL([orm].[ship_to_phone],'555-555-5555') AS [consignee/phone], 
                        ISNULL([orm].[ship_to_country_code],'') AS [consignee/countryCode], 
                        (SELECT  
                        (SELECT [pkd3].[item_number] AS [productCode], 
                        [itm3].[description] AS [description], 
                        CAST(CAST([pkd3].[picked_quantity] AS NUMERIC(18,2)) AS INT) AS [quantity],  
                        CAST([itm3].[unit_weight] AS NUMERIC(18,2)) AS [unitWeight/amount], 
                        CAST(ISNULL([itm3].[price],'0.00') AS NUMERIC(18,2)) AS [unitValue/amount], 
                        CASE WHEN [itm3].[tmk_company_id] > 1 
                        THEN 'UNITED_STATES' 
                        ELSE 'CHINA' 
                        END AS [originCountry] 
                        FROM t_pick_detail AS pkd3 
                        INNER JOIN t_item_master AS itm3 
                        ON itm3.item_number = pkd3.item_number 
                        AND itm3.wh_id = pkd3.wh_id 
                        WHERE pkd3.wh_id = orm.wh_id 
                        AND pkd3.order_number = orm.order_number 
                        AND pkd3.container_id = '14574875' 
                        ORDER BY orm.wh_id, 
                        orm.order_number FOR XML PATH('item'),ELEMENTS,TYPE 
                        ) FOR XML PATH('commodityContents'),ELEMENTS,TYPE 
                        ) FOR XML PATH('defaults'),ELEMENTS,TYPE 
                        ), 
                        (SELECT (SELECT CASE 
                        WHEN CAST([uom3].[length] AS NUMERIC(18,2)) >= CAST([uom3].[width] AS NUMERIC(18,2)) AND CAST([uom3].[length] AS NUMERIC(18,2)) >= CAST([uom3].[height] AS NUMERIC(18,2)) THEN CAST([uom3].[length] AS NUMERIC(18,2)) 
                        WHEN CAST([uom3].[width] AS NUMERIC(18,2)) >= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[width] AS NUMERIC(18,2)) >= CAST([uom3].[height] AS NUMERIC(18,2)) THEN CAST([uom3].[width] AS NUMERIC(18,2)) 
                        WHEN CAST([uom3].[height] AS NUMERIC(18,2)) >= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[height] AS NUMERIC(18,2)) >= CAST([uom3].[width] AS NUMERIC(18,2)) THEN CAST([uom3].[height] AS NUMERIC(18,2)) 
                        END AS [dimension/length], 
                        CASE 
                        WHEN (CAST([uom3].[length] AS NUMERIC(18,2)) >= CAST([uom3].[width] AS NUMERIC(18,2)) AND CAST([uom3].[length] AS NUMERIC(18,2)) <= CAST([uom3].[height] AS NUMERIC(18,2))) OR (CAST([uom3].[length] AS NUMERIC(18,2)) <= CAST([uom3].[width] AS NUMERIC(18,2)) AND CAST([uom3].[length] AS NUMERIC(18,2)) >= CAST([uom3].[height] AS NUMERIC(18,2)))  THEN CAST([uom3].[length] AS NUMERIC(18,2)) 
                        WHEN (CAST([uom3].[width] AS NUMERIC(18,2)) >= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[width] AS NUMERIC(18,2)) <= CAST([uom3].[height] AS NUMERIC(18,2))) OR (CAST([uom3].[width] AS NUMERIC(18,2)) <= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[width] AS NUMERIC(18,2)) >= CAST([uom3].[height] AS NUMERIC(18,2)))  THEN CAST([uom3].[width] AS NUMERIC(18,2)) 
                        WHEN (CAST([uom3].[height] AS NUMERIC(18,2)) >= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[height] AS NUMERIC(18,2)) <= CAST([uom3].[width] AS NUMERIC(18,2))) OR (CAST([uom3].[height] AS NUMERIC(18,2)) <= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[height] AS NUMERIC(18,2)) >= CAST([uom3].[width] AS NUMERIC(18,2))) THEN CAST([uom3].[height] AS NUMERIC(18,2)) 
                        END AS [dimension/width], 
                        CASE 
                        WHEN CAST([uom3].[length] AS NUMERIC(18,2)) <= CAST([uom3].[width] AS NUMERIC(18,2)) AND CAST([uom3].[length] AS NUMERIC(18,2)) <= CAST([uom3].[height] AS NUMERIC(18,2)) THEN CAST([uom3].[length] AS NUMERIC(18,2)) 
                        WHEN CAST([uom3].[width] AS NUMERIC(18,2)) <= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[width] AS NUMERIC(18,2)) <= CAST([uom3].[height] AS NUMERIC(18,2)) THEN CAST([uom3].[width] AS NUMERIC(18,2)) 
                        WHEN CAST([uom3].[height] AS NUMERIC(18,2)) <= CAST([uom3].[length] AS NUMERIC(18,2)) AND CAST([uom3].[height] AS NUMERIC(18,2)) <= CAST([uom3].[width] AS NUMERIC(18,2)) THEN CAST([uom3].[height] AS NUMERIC(18,2)) 
                        END AS [dimension/height], 
                        CAST([itm4].[unit_weight] AS NUMERIC(18,2)) AS [weight/amount], 
                        '0.00' AS [declaredValueAmount/amount],  
                        [orm4].[ship_to_country_name] AS [ultimateDestinationCountry] 
                        FROM t_order AS orm4 
                        INNER JOIN t_pick_detail AS pkd4  
                        ON pkd4.order_number = orm4.order_number 
                        AND pkd4.wh_id = orm4.wh_id 
                        INNER JOIN t_item_master AS itm4 
                        ON itm4.item_number = pkd4.item_number 
                        AND itm4.wh_id = pkd4.wh_id 
                        INNER JOIN t_item_uom AS uom3 
                        ON uom3.item_number = itm4.item_number 
                        AND uom3.wh_id = itm4.wh_id 
                        WHERE  pkd4.wh_id = orm.wh_id 
                        AND pkd4.order_number = orm.order_number 
                        AND pkd4.container_id = '14574875' 
                        ORDER BY orm.wh_id, 
                        orm.order_number FOR XML PATH('item'),ELEMENTS,TYPE 
                        ) FOR XML PATH('packages'),ELEMENTS,TYPE 
                        ), 
                        'true' AS [saveTransaction], 
                        'release' AS [closeOutMode] FOR XML PATH('shipRequest'),ELEMENTS,TYPE 
                        ), 
                        'CONNECTSHIP_UPS_MAXICODE_PACKAGE_LABEL.STANDARD' AS [printRequest/document], 
                        'generic.zpl' AS [printRequest/output], 
                        'response' AS [printRequest/destination], 
                        'THERMAL_LABEL_8' AS [printRequest/stock/symbol], 
                        (SELECT DISTINCT  
                        o.order_number AS [ordernumber], 
                        o.wh_id AS [whid], 
                        o.tmk_ship_to_name AS [tmkshiptoname], 
                        o.tmk_ship_to_address1 AS [shipaddress1], 
                        o.tmk_ship_to_address2 AS [shipaddress2], 
                        o.ship_to_city AS [shipcity], 
                        o.ship_to_state AS [shipstate], 
                        o.ship_to_zip AS [shipzip], 
                        o.ship_to_phone AS [shipphone], 
                        o.ship_to_country_name AS [shipcountry], 
                        o.return_to_name AS [returnname], 
                        o.tmk_return_to_address1 AS [returnaddress1], 
                        o.tmk_return_to_address2 AS [returnaddress2], 
                        o.return_to_city AS [returncity], 
                        o.return_to_state AS [returnstate], 
                        o.return_to_country_name AS [returncountry], 
                        o.return_to_zip AS [returnzip], 
                        o.return_to_phone AS [returnphone], 
                        tsv.ship_via AS [shipvia], 
                        sas.AccountNumber AS [accountnumber], 
                        sas.ShipperCode AS [shippercode], 
                        sas.NameOnAccount AS [nameonaccount], 
                        sas.Address AS [address], 
                        sas.City AS [city], 
                        sas.State AS [state], 
                        sas.PostalCode AS [postalcode], 
                        sas.Country AS [country], 
                        o.freight_terms AS [freightterms], 
                        o.insurance_amount AS [insuranceamount], 
                        o.customer_name AS [customername], 
                        tom.sat_delivery_flag AS [satdeliveryflag], 
                        tom.tmk_upsmi_cost_center AS [costcenter], 
                        tom.tmk_route_request_confirm_no AS [routerequest], 
                        tom.tmk_shipping_terms AS [shippingterms], 
                        tom.tmk_delivery_confirmation AS [deliveryconfirmation], 
                        tom.tmk_use_return_label AS [returnlabel], 
                        tom.registered_mail_flag AS [registeredmailflag], 
                        tom.tmk_ref1 AS [ref1], 
                        tom.tmk_ref2 AS [ref2], 
                        tom.tmk_ref4 AS [ref4], 
                        tom.tmk_ref5 AS [ref5], 
                        tom.tmk_ref10 AS [ref10], 
                        tom.tmk_ref11 AS [ref11], 
                        tom.tmk_ref12 AS [ref12], 
                        tom.tmk_ref13 AS [ref13] 
                        FROM t_pick_detail AS pd 
                        INNER JOIN t_pick_container AS pc 
                        ON pc.container_id = pd.container_id 
                        AND pc.wh_id = pd.wh_id 
                        INNER JOIN t_order AS o 
                        ON o.order_number = pd.order_number 
                        AND o.wh_id = pd.wh_id 
                        LEFT JOIN t_ship_via AS tsv 
                        ON pc.ship_via_id = tsv.ship_via_id 
                        LEFT JOIN t_order_manifest AS tom
                                              ON tom.order_id = o.order_id
                                          LEFT JOIN t_customer cust ON cust.customer_id = o.customer_id
                                          LEFT JOIN ShippingAccounts sas ON sas.CustomerId = cust.customer_code
                                          AND o.wh_id = sas.Warehouse AND sas.IsActive = 'Y' AND sas.[Primary] = 'Y' AND o.carrier = sas.CarrierCode AND UPPER([o].[freight_terms]) = UPPER([sas].[AccountType]) /*DISTRO-457 AFB (4S) Per BB*/
                                       WHERE  o.wh_id = orm.wh_id
                                            AND o.order_number = orm.order_number
                                                         AND pc.container_id = pkc.container_id FOR XML PATH('detail'),ELEMENTS,TYPE
                                                    )
                                              FROM [t_order] AS [orm]
                                                  INNER JOIN [t_pick_container] AS [pkc]
                                                      ON [orm].[wh_id] = [pkc].[wh_id]
                                                        AND [orm].[order_number] = [pkc].[order_number]
                                                  LEFT JOIN [t_ship_via] AS [sv]
                                                      ON [pkc].[ship_via_id] = [sv].[ship_via_id]
                                                  LEFT JOIN [ShippingAccounts] AS [sa]
                                                      ON [pkc].[wh_id] = [sa].[Warehouse]
                                                AND [pkc].[tmk_shipping_account_id] = [sa].[ShippingAccountId]
                                              AND [orm].[wh_id] = [sa].[Warehouse] AND [sa].[IsActive] = 'Y' AND [sa].[Primary] = 'Y' AND [orm].[carrier] = [sa].[CarrierCode] AND UPPER([orm].[freight_terms]) = UPPER([sa].[AccountType])
                        WHERE [pkc].[wh_id] = 'CLE2' 
                        AND [pkc].[container_id] = '14574875' 
                        AND [pkc].[order_number] = '38390172' FOR XML PATH('compoundOperation')