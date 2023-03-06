//SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "./IERC5489.sol";

contract ERC5489 is IERC5489, ERC721Enumerable, Ownable {
    mapping(uint256 => mapping(address=> string)) tokenId2Address2Value;
    mapping(uint256 => string) tokenId2ImageUri;

    string private _imageURI;
    string private _name;

    constructor() ERC721("Hyperlink NFT Collection", "HNFT") {}

    function setSlotUri(uint256 tokenId, string calldata value) override external {
        tokenId2Address2Value[tokenId][_msgSender()] = value;

        emit SlotUriUpdated(tokenId, _msgSender(), value);
    }

    function getSlotUri(uint256 tokenId, address slotManagerAddr) override external view returns (string memory) {
        return tokenId2Address2Value[tokenId][slotManagerAddr];
    }

    function _mintToken(uint256 tokenId, string calldata imageUri) private {
        _safeMint(msg.sender, tokenId);
        tokenId2ImageUri[tokenId] = imageUri;
    }

    function mint(string calldata imageUri) external {
        uint256 tokenId = totalSupply() + 1;
        _mintToken(tokenId, imageUri);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(
            _exists(_tokenId),
            "URI query for nonexistent token"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                abi.encodePacked(
                                    _name,
                                    " # ",
                                    Strings.toString(_tokenId)
                                ),
                                '",',
                                '"description":"Hyperlink NFT collection created with Parami Foundation"',
                                '}'
                            )
                        )
                    )
                )
            );
    }
}
