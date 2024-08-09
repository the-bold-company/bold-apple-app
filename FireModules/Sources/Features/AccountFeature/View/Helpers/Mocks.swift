import Foundation

let categoryListMock = """
{
    "message": "Execute successfully",
    "data": [
        {
            "id": "1ee5a461-7b00-473e-b23a-856173e7bf81",
            "type": "money-in",
            "icon": "green_square",
            "name": "Sugarbaby",
            "level": 0
        },
        {
            "id": "7a32b2cd-9159-4b0b-9c88-63200511aad6",
            "type": "money-in",
            "icon": "green_square",
            "name": "Baby 1",
            "level": 1,
            "parentId": "1ee5a461-7b00-473e-b23a-856173e7bf81"
        },
        {
            "id": "6547a713-d3df-423d-a764-b8d71af6d66a",
            "type": "money-in",
            "icon": "green_square",
            "name": "Baby 2",
            "level": 1,
            "parentId": "1ee5a461-7b00-473e-b23a-856173e7bf81"
        },
        {
            "id": "8cab19f6-59a9-4e39-b1bb-ded4d663567b",
            "type": "money-in",
            "icon": "green_square",
            "name": "Salary",
            "level": 0
        },
        {
            "id": "bb5195e3-6345-4d25-9622-e6d5c1be4eca",
            "type": "money-in",
            "icon": "green_square",
            "name": "Freelance",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "27e6a10b-34e2-45d2-a752-f3b8f105b6d0",
            "type": "money-in",
            "icon": "green_square",
            "name": "9-5",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "ebd779b3-93e3-497e-a9dd-fb2dde1e41b4",
            "type": "money-in",
            "icon": "green_square",
            "name": "stock",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "d371345e-6846-4f59-81dd-39bbfa7ddc41",
            "type": "money-in",
            "icon": "green_square",
            "name": "tiktok",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3",
            "type": "money-in",
            "icon": "green_square",
            "name": "Social Media",
            "level": 0
        },
        {
            "id": "c18b7311-b42b-45ac-810d-be214815efb4",
            "type": "money-in",
            "icon": "green_square",
            "name": "Youtube",
            "level": 1,
            "parentId": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3"
        },
        {
            "id": "332fc28b-f55d-4672-b8af-71efcd6b4542",
            "type": "money-in",
            "icon": "green_square",
            "name": "X",
            "level": 1,
            "parentId": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3"
        },
        {
            "id": "c5a3465e-b718-428e-bc37-f33ab8c3679e",
            "type": "money-in",
            "icon": "green_square",
            "name": "Instagram",
            "level": 1,
            "parentId": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3"
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf90",
          "type": "money-in",
          "icon": "green_square",
          "name": "Gambling",
          "level": 0
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf91",
          "type": "money-in",
          "icon": "green_square",
          "name": "Inherit",
          "level": 0
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf92",
          "type": "money-in",
          "icon": "green_square",
          "name": "Others",
          "level": 0
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf93",
          "type": "money-in",
          "icon": "green_square",
          "name": "Back Street Boys",
          "level": 0
        }
    ],
    "code": 200
}
"""

let accountListMock = """
{
    "message": "Execute successfully",
    "data": [
      {
        "id": "f8f23688-dad5-4070-9e44-3067a7589b56",
        "name": "Timo",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": ":bank:",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "0628a17a-977a-46d6-929c-ae40f40ad104",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 1500000,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "f8f23688-dad5-4070-9e44-3067a7589b56",
            "index": 0
          }
        ]
      },
      {
        "id": "527e3b42-a52b-49c0-bc2a-b72995fc6081",
        "name": "TCB",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "51aeeee0-aaff-4d7c-82be-cf2136d0f07f",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 0,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "527e3b42-a52b-49c0-bc2a-b72995fc6081",
            "index": 0
          }
        ]
      },
      {
        "id": "f3bf361f-0537-4e98-a190-083ddece509f",
        "name": "TCB",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "3d3b9a8c-8adb-47d2-a45e-703c9f7fa021",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 0,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "f3bf361f-0537-4e98-a190-083ddece509f",
            "index": 0
          }
        ]
      },
      {
        "id": "820b47d2-84d9-4a7a-9ac6-3d7d5bdd1004",
        "name": "TCB",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "605eec58-e6a5-4ff4-981a-e648f1302bbe",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 0,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "820b47d2-84d9-4a7a-9ac6-3d7d5bdd1004",
            "index": 0
          }
        ]
      },
      {
        "id": "f9e62cc2-b7dc-4b5a-a92b-253838c439a9",
        "name": "Timo",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "95a3e3b0-930c-42e5-b62c-b2bfceb43a96",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 123000,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "f9e62cc2-b7dc-4b5a-a92b-253838c439a9",
            "index": 0
          }
        ]
      },
      {
        "id": "971a5714-9159-456b-93f0-effadd0cd6c3",
        "name": "Timo",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "a3cfdba6-d2fd-425b-a476-d4a773d2f826",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 123000,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "971a5714-9159-456b-93f0-effadd0cd6c3",
            "index": 0
          }
        ]
      },
      {
        "id": "4f508f0e-bdd7-413e-9cdf-2c6f675643ff",
        "name": "Cake",
        "type": "bank-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "45edec00-d6b1-46ec-819b-a2f1c9aeb8d3",
            "name": "BANK_ACCOUNT_CURRENT_BALANCE",
            "value": 0,
            "valueType": "NumberType",
            "title": "Số tiền hiện có",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "4f508f0e-bdd7-413e-9cdf-2c6f675643ff",
            "index": 0
          }
        ]
      },
      {
        "id": "04663c31-eea9-4324-9e16-958264d3f751",
        "name": "Ck Cr",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "50963544-5699-4bee-b06a-4cf950ff2e21",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 123000000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "04663c31-eea9-4324-9e16-958264d3f751",
            "index": 0
          },
          {
            "id": "50963544-5699-4bee-b06a-4cf950ff2e21",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "04663c31-eea9-4324-9e16-958264d3f751",
            "index": 1
          },
          {
            "id": "50963544-5699-4bee-b06a-4cf950ff2e21",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "04663c31-eea9-4324-9e16-958264d3f751",
            "index": 2
          },
          {
            "id": "50963544-5699-4bee-b06a-4cf950ff2e21",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "04663c31-eea9-4324-9e16-958264d3f751",
            "index": 3
          }
        ]
      },
      {
        "id": "c58d6fcd-988c-46c1-b94f-f0a861053f69",
        "name": "Ck Cr 1",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "80985085-3bd6-4929-935e-bbab395010d3",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 123000000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "c58d6fcd-988c-46c1-b94f-f0a861053f69",
            "index": 0
          },
          {
            "id": "80985085-3bd6-4929-935e-bbab395010d3",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "c58d6fcd-988c-46c1-b94f-f0a861053f69",
            "index": 1
          },
          {
            "id": "80985085-3bd6-4929-935e-bbab395010d3",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "c58d6fcd-988c-46c1-b94f-f0a861053f69",
            "index": 2
          },
          {
            "id": "80985085-3bd6-4929-935e-bbab395010d3",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "c58d6fcd-988c-46c1-b94f-f0a861053f69",
            "index": 3
          }
        ]
      },
      {
        "id": "ea782125-5e7b-44f2-8232-51191f5aa17e",
        "name": "Ck Cr 2",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "1d0a387a-673c-4d10-837e-e8ed612b01fc",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 123000000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ea782125-5e7b-44f2-8232-51191f5aa17e",
            "index": 0
          },
          {
            "id": "1d0a387a-673c-4d10-837e-e8ed612b01fc",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ea782125-5e7b-44f2-8232-51191f5aa17e",
            "index": 1
          },
          {
            "id": "1d0a387a-673c-4d10-837e-e8ed612b01fc",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ea782125-5e7b-44f2-8232-51191f5aa17e",
            "index": 2
          },
          {
            "id": "1d0a387a-673c-4d10-837e-e8ed612b01fc",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ea782125-5e7b-44f2-8232-51191f5aa17e",
            "index": 3
          }
        ]
      },
      {
        "id": "a6e577c7-c483-41b6-85e4-cbbfbbb56490",
        "name": "Ck cr 5  ",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "d70c4038-a165-40a8-ae96-36b9b9355ba3",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 1230000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "a6e577c7-c483-41b6-85e4-cbbfbbb56490",
            "index": 0
          },
          {
            "id": "d70c4038-a165-40a8-ae96-36b9b9355ba3",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "a6e577c7-c483-41b6-85e4-cbbfbbb56490",
            "index": 1
          },
          {
            "id": "d70c4038-a165-40a8-ae96-36b9b9355ba3",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "a6e577c7-c483-41b6-85e4-cbbfbbb56490",
            "index": 2
          },
          {
            "id": "d70c4038-a165-40a8-ae96-36b9b9355ba3",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "a6e577c7-c483-41b6-85e4-cbbfbbb56490",
            "index": 3
          }
        ]
      },
      {
        "id": "b33cdb9a-77a4-4782-ac6d-99e6b314265e",
        "name": "Ck cr 5  ",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "5499ec23-0e6c-47b3-892d-ca2832a57d6c",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 1230000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "b33cdb9a-77a4-4782-ac6d-99e6b314265e",
            "index": 0
          },
          {
            "id": "5499ec23-0e6c-47b3-892d-ca2832a57d6c",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "b33cdb9a-77a4-4782-ac6d-99e6b314265e",
            "index": 1
          },
          {
            "id": "5499ec23-0e6c-47b3-892d-ca2832a57d6c",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "b33cdb9a-77a4-4782-ac6d-99e6b314265e",
            "index": 2
          },
          {
            "id": "5499ec23-0e6c-47b3-892d-ca2832a57d6c",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "b33cdb9a-77a4-4782-ac6d-99e6b314265e",
            "index": 3
          }
        ]
      },
      {
        "id": "dcf41738-fcd9-4cf2-ab2b-4076d3a5ca39",
        "name": "Ck cr 5  ",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "a22ea80d-c9d7-4e38-b534-71a28b7ec2c7",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 1230000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "dcf41738-fcd9-4cf2-ab2b-4076d3a5ca39",
            "index": 0
          },
          {
            "id": "a22ea80d-c9d7-4e38-b534-71a28b7ec2c7",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "dcf41738-fcd9-4cf2-ab2b-4076d3a5ca39",
            "index": 1
          },
          {
            "id": "a22ea80d-c9d7-4e38-b534-71a28b7ec2c7",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "dcf41738-fcd9-4cf2-ab2b-4076d3a5ca39",
            "index": 2
          },
          {
            "id": "a22ea80d-c9d7-4e38-b534-71a28b7ec2c7",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "dcf41738-fcd9-4cf2-ab2b-4076d3a5ca39",
            "index": 3
          }
        ]
      },
      {
        "id": "ffb9d8c3-119b-4e2f-9e9d-0fab3994cea8",
        "name": "Ck cr 5  ",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "096fe7f8-c7af-4dcf-9c0d-85fd91e0c43e",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 1230000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ffb9d8c3-119b-4e2f-9e9d-0fab3994cea8",
            "index": 0
          },
          {
            "id": "096fe7f8-c7af-4dcf-9c0d-85fd91e0c43e",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ffb9d8c3-119b-4e2f-9e9d-0fab3994cea8",
            "index": 1
          },
          {
            "id": "096fe7f8-c7af-4dcf-9c0d-85fd91e0c43e",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ffb9d8c3-119b-4e2f-9e9d-0fab3994cea8",
            "index": 2
          },
          {
            "id": "096fe7f8-c7af-4dcf-9c0d-85fd91e0c43e",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "ffb9d8c3-119b-4e2f-9e9d-0fab3994cea8",
            "index": 3
          }
        ]
      },
      {
        "id": "3496716c-79f0-4c27-b2d5-228e998763aa",
        "name": "Ck cr 5  ",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "9e2fa72f-9240-4dc2-b109-776f15fd31dd",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 1230000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "3496716c-79f0-4c27-b2d5-228e998763aa",
            "index": 0
          },
          {
            "id": "9e2fa72f-9240-4dc2-b109-776f15fd31dd",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "3496716c-79f0-4c27-b2d5-228e998763aa",
            "index": 1
          },
          {
            "id": "9e2fa72f-9240-4dc2-b109-776f15fd31dd",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "3496716c-79f0-4c27-b2d5-228e998763aa",
            "index": 2
          },
          {
            "id": "9e2fa72f-9240-4dc2-b109-776f15fd31dd",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "3496716c-79f0-4c27-b2d5-228e998763aa",
            "index": 3
          }
        ]
      },
      {
        "id": "978480fe-4891-4cd8-8707-45841d695dfd",
        "name": "Creeeeeeeeeeeee",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "010559e0-5dbc-4307-8e23-42244919c43b",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 135000000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "978480fe-4891-4cd8-8707-45841d695dfd",
            "index": 0
          },
          {
            "id": "010559e0-5dbc-4307-8e23-42244919c43b",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "978480fe-4891-4cd8-8707-45841d695dfd",
            "index": 1
          },
          {
            "id": "010559e0-5dbc-4307-8e23-42244919c43b",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 1,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "978480fe-4891-4cd8-8707-45841d695dfd",
            "index": 2
          },
          {
            "id": "010559e0-5dbc-4307-8e23-42244919c43b",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 10,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "978480fe-4891-4cd8-8707-45841d695dfd",
            "index": 3
          }
        ]
      },
      {
        "id": "44831319-e531-4330-9965-450c339ae8b9",
        "name": "Creeeeeeee",
        "type": "credit-account",
        "status": "ACTIVE",
        "icon": "",
        "currencyId": "VND",
        "userId": "694a554c-c091-706a-d9aa-f6d389907efb",
        "cells": [
          {
            "id": "bec78261-bf66-4f74-9dc1-798e17acb94c",
            "name": "CREDIT_ACCOUNT_CURRENT_DEBT",
            "value": 1350000000,
            "valueType": "NumberType",
            "title": "Dư nợ hiện tại",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "44831319-e531-4330-9965-450c339ae8b9",
            "index": 0
          },
          {
            "id": "bec78261-bf66-4f74-9dc1-798e17acb94c",
            "name": "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT",
            "value": 0,
            "valueType": "NumberType",
            "title": "Tổng hạn mức",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "44831319-e531-4330-9965-450c339ae8b9",
            "index": 1
          },
          {
            "id": "bec78261-bf66-4f74-9dc1-798e17acb94c",
            "name": "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE",
            "value": 2,
            "valueType": "NumberType",
            "title": "Ngày chốt sao kê",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "44831319-e531-4330-9965-450c339ae8b9",
            "index": 2
          },
          {
            "id": "bec78261-bf66-4f74-9dc1-798e17acb94c",
            "name": "CREDIT_ACCOUNT_PAYMENT_DATE",
            "value": 11,
            "valueType": "NumberType",
            "title": "Sao kê hàng tháng",
            "createdBy": "694a554c-c091-706a-d9aa-f6d389907efb",
            "accountId": "44831319-e531-4330-9965-450c339ae8b9",
            "index": 3
          }
        ]
      }
    ],
    "code": 200
  }
"""
