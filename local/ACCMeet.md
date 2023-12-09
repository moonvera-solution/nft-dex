
We prariotize community minting costs over collection listing costs
We dont charge per Nft transaction like other big Markets

Artist will invest in listing costs to recover it on sales.

ACC has no restriction referring

If user has Balance in ACC 721 collection (ACC member)
    - Set Artist Role => deploy collection ones with 20% discount

If Artist deploys has to pay
    - Deployment gas costs      $50 - 100 USD
    - Deployment fees .333 eth  $520.00
    ---------------------------------
    Approx of $600.00 with gas or les

    20% discount = $105.00
    20% Referal = $105.00
    10% Partner = $50.00
    50% mvx = $250.00
    _________________________________
    Artist pay approx $500 including gas cost
        - Artist website inside launchpad
        - no minting gas
        - moonver.com/artist/nft-collection
    
Launchpad
Advertising Addons:
    - Collection featured on landing page
    - Trending banner space

Model 2:
2% of the total Sales, locked on contract charged at artist withdraw


Taint Analysis - Threat Modeling

We need to have the control on who do we allow to WL ppl for deploying in OUR LAUNCHPAD.


Roles
Admin - grants all roles
Members
    - mvx member
    - 721 member becomes member at acc collection deploy
    - artist

Priviledges (all revoked after _createCollection tx)
    - mxv member -> _createCollection
    - 721 member -> grant artist role
    - artist -> _createCollection

Money Flows
    - mvx member => platform 
    - acc member => platform 
    - artist => platform
                    => keeps
                    => 721 member
                    => 721 admin

Keep track of variable discount rates per 721
mapping(address coll => uint256 discount) discounts;

mapping
// mapping(address sender => mapping(string roleType => address artists) members;

MvxMember
Artist
Intent based architecture
use meta transactions as way of contract communication


