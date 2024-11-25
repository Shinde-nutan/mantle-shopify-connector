<#ftl output_format="HTML">
<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<@compress single_line=true>
    <#if queryParams?has_content>
        <#if queryParams.filterQuery?has_content>
            <#assign filterQuery = queryParams.filterQuery/>
        <#else>
            <#if queryParams.fromDateLabel?has_content>
              <#assign fromDateLabel = queryParams.fromDateLabel/>
            <#else>
              <#assign fromDateLabel = "created_at"/>
            </#if>
            <#if queryParams.thruDateLabel?has_content>
                <#assign thruDateLabel = queryParams.thruDateLabel/>
            <#else>
                <#assign thruDateLabel = "created_at"/>
            </#if>
            <#if queryParams.fromDate?has_content && !queryParams.thruDate?has_content>
                <#assign filterQuery = "${fromDateLabel}:>'${queryParams.fromDate}'"/>
            </#if>
            <#if queryParams.thruDate?has_content && !queryParams.fromDate?has_content>
                <#assign filterQuery = "${thruDateLabel}:<'${queryParams.thruDate}'"/>
            </#if>
            <#if queryParams.fromDate?has_content && queryParams.thruDate?has_content>
                <#assign filterQuery = "${fromDateLabel}:>'${queryParams.fromDate}' AND ${thruDateLabel}:<'${queryParams.thruDate}'"/>
            </#if>
        </#if>
    </#if>

    mutation {
        bulkOperationRunQuery(
            query: """
            {
              products <#if filterQuery?has_content>(query:"${filterQuery}")</#if> {
                edges {
                  node {
                    id
                    title
                    handle
                    description
                    productType
                    options{
                        id
                        name
                        position
                    }
                    status
                    tags
                    media {
                      edges {
                        node {
                          id
                          alt
                          mediaContentType
                          ... on MediaImage {
                            image {
                              id
                              altText
                              src
                            }
                          }
                        }
                      }
                    }
                    variants {
                      edges {
                        node {
                          id
                          title
                          sku
                          barcode
                          price
                          compareAtPrice
                          inventoryItem{
                          id
                          }
                          weight
                          weightUnit
                          image {
                            id
                            src
                            altText
                          }
                          selectedOptions {
                            name
                            value
                          }
                          inventoryQuantity
                          requiresShipping
                          product {
                            id
                            title
                          }
                          metafields{
                           edges {
                            node {
                              id
                              namespace
                              key
                              value
                              type
                              description
                              createdAt
                              updatedAt
                            }
                          }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }

        """ ) {
            bulkOperation {
                id
                status
            }
            userErrors {
                field
                message
            }
        }
    }

</@compress>
