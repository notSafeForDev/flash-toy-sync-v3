/**
 * This script has to be run before the ActionScript 2.0 version can be compiled
 * 
 * It copies directories and files from flash-toy-sync-as3 to flash-toy-sync-as2
 * Then transpiles the Actionscript 3.0 code into 2.0
 * 
 * Note: It won't necessarily work for any other Actionscript 3.0 file, as it is only written based on the code that should be transpiled
 */

// https://stackoverflow.com/a/26038979

var fs = require('fs');
var path = require('path');

const MUST_END_WITH_NO_CHARACTER = 0;
const MUST_END_WITH_ANY_CHARACTER = 1;
const MUST_END_WITH_VALID_VARIABLE_CHARACTER = 2;
const MUST_END_WITH_INVALID_VARIABLE_CHARACTER = 3;

var validASCIIVariableNameRegex = /^(?!(?:do|if|in|for|let|new|try|var|case|else|enum|eval|false|null|undefined|NaN|this|true|void|with|break|catch|class|const|super|throw|while|yield|delete|export|import|public|return|static|switch|typeof|default|extends|finally|package|private|continue|debugger|function|arguments|interface|protected|implements|instanceof)$)[$A-Z\_a-z\xaa\xb5\xba\xc0-\xd6\xd8-\xf6\xf8-\u02c1\u02c6-\u02d1\u02e0-\u02e4\u02ec\u02ee\u0370-\u0374\u0376\u0377\u037a-\u037d\u0386\u0388-\u038a\u038c\u038e-\u03a1\u03a3-\u03f5\u03f7-\u0481\u048a-\u0527\u0531-\u0556\u0559\u0561-\u0587\u05d0-\u05ea\u05f0-\u05f2\u0620-\u064a\u066e\u066f\u0671-\u06d3\u06d5\u06e5\u06e6\u06ee\u06ef\u06fa-\u06fc\u06ff\u0710\u0712-\u072f\u074d-\u07a5\u07b1\u07ca-\u07ea\u07f4\u07f5\u07fa\u0800-\u0815\u081a\u0824\u0828\u0840-\u0858\u08a0\u08a2-\u08ac\u0904-\u0939\u093d\u0950\u0958-\u0961\u0971-\u0977\u0979-\u097f\u0985-\u098c\u098f\u0990\u0993-\u09a8\u09aa-\u09b0\u09b2\u09b6-\u09b9\u09bd\u09ce\u09dc\u09dd\u09df-\u09e1\u09f0\u09f1\u0a05-\u0a0a\u0a0f\u0a10\u0a13-\u0a28\u0a2a-\u0a30\u0a32\u0a33\u0a35\u0a36\u0a38\u0a39\u0a59-\u0a5c\u0a5e\u0a72-\u0a74\u0a85-\u0a8d\u0a8f-\u0a91\u0a93-\u0aa8\u0aaa-\u0ab0\u0ab2\u0ab3\u0ab5-\u0ab9\u0abd\u0ad0\u0ae0\u0ae1\u0b05-\u0b0c\u0b0f\u0b10\u0b13-\u0b28\u0b2a-\u0b30\u0b32\u0b33\u0b35-\u0b39\u0b3d\u0b5c\u0b5d\u0b5f-\u0b61\u0b71\u0b83\u0b85-\u0b8a\u0b8e-\u0b90\u0b92-\u0b95\u0b99\u0b9a\u0b9c\u0b9e\u0b9f\u0ba3\u0ba4\u0ba8-\u0baa\u0bae-\u0bb9\u0bd0\u0c05-\u0c0c\u0c0e-\u0c10\u0c12-\u0c28\u0c2a-\u0c33\u0c35-\u0c39\u0c3d\u0c58\u0c59\u0c60\u0c61\u0c85-\u0c8c\u0c8e-\u0c90\u0c92-\u0ca8\u0caa-\u0cb3\u0cb5-\u0cb9\u0cbd\u0cde\u0ce0\u0ce1\u0cf1\u0cf2\u0d05-\u0d0c\u0d0e-\u0d10\u0d12-\u0d3a\u0d3d\u0d4e\u0d60\u0d61\u0d7a-\u0d7f\u0d85-\u0d96\u0d9a-\u0db1\u0db3-\u0dbb\u0dbd\u0dc0-\u0dc6\u0e01-\u0e30\u0e32\u0e33\u0e40-\u0e46\u0e81\u0e82\u0e84\u0e87\u0e88\u0e8a\u0e8d\u0e94-\u0e97\u0e99-\u0e9f\u0ea1-\u0ea3\u0ea5\u0ea7\u0eaa\u0eab\u0ead-\u0eb0\u0eb2\u0eb3\u0ebd\u0ec0-\u0ec4\u0ec6\u0edc-\u0edf\u0f00\u0f40-\u0f47\u0f49-\u0f6c\u0f88-\u0f8c\u1000-\u102a\u103f\u1050-\u1055\u105a-\u105d\u1061\u1065\u1066\u106e-\u1070\u1075-\u1081\u108e\u10a0-\u10c5\u10c7\u10cd\u10d0-\u10fa\u10fc-\u1248\u124a-\u124d\u1250-\u1256\u1258\u125a-\u125d\u1260-\u1288\u128a-\u128d\u1290-\u12b0\u12b2-\u12b5\u12b8-\u12be\u12c0\u12c2-\u12c5\u12c8-\u12d6\u12d8-\u1310\u1312-\u1315\u1318-\u135a\u1380-\u138f\u13a0-\u13f4\u1401-\u166c\u166f-\u167f\u1681-\u169a\u16a0-\u16ea\u16ee-\u16f0\u1700-\u170c\u170e-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176c\u176e-\u1770\u1780-\u17b3\u17d7\u17dc\u1820-\u1877\u1880-\u18a8\u18aa\u18b0-\u18f5\u1900-\u191c\u1950-\u196d\u1970-\u1974\u1980-\u19ab\u19c1-\u19c7\u1a00-\u1a16\u1a20-\u1a54\u1aa7\u1b05-\u1b33\u1b45-\u1b4b\u1b83-\u1ba0\u1bae\u1baf\u1bba-\u1be5\u1c00-\u1c23\u1c4d-\u1c4f\u1c5a-\u1c7d\u1ce9-\u1cec\u1cee-\u1cf1\u1cf5\u1cf6\u1d00-\u1dbf\u1e00-\u1f15\u1f18-\u1f1d\u1f20-\u1f45\u1f48-\u1f4d\u1f50-\u1f57\u1f59\u1f5b\u1f5d\u1f5f-\u1f7d\u1f80-\u1fb4\u1fb6-\u1fbc\u1fbe\u1fc2-\u1fc4\u1fc6-\u1fcc\u1fd0-\u1fd3\u1fd6-\u1fdb\u1fe0-\u1fec\u1ff2-\u1ff4\u1ff6-\u1ffc\u2071\u207f\u2090-\u209c\u2102\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126\u2128\u212a-\u212d\u212f-\u2139\u213c-\u213f\u2145-\u2149\u214e\u2160-\u2188\u2c00-\u2c2e\u2c30-\u2c5e\u2c60-\u2ce4\u2ceb-\u2cee\u2cf2\u2cf3\u2d00-\u2d25\u2d27\u2d2d\u2d30-\u2d67\u2d6f\u2d80-\u2d96\u2da0-\u2da6\u2da8-\u2dae\u2db0-\u2db6\u2db8-\u2dbe\u2dc0-\u2dc6\u2dc8-\u2dce\u2dd0-\u2dd6\u2dd8-\u2dde\u2e2f\u3005-\u3007\u3021-\u3029\u3031-\u3035\u3038-\u303c\u3041-\u3096\u309d-\u309f\u30a1-\u30fa\u30fc-\u30ff\u3105-\u312d\u3131-\u318e\u31a0-\u31ba\u31f0-\u31ff\u3400-\u4db5\u4e00-\u9fcc\ua000-\ua48c\ua4d0-\ua4fd\ua500-\ua60c\ua610-\ua61f\ua62a\ua62b\ua640-\ua66e\ua67f-\ua697\ua6a0-\ua6ef\ua717-\ua71f\ua722-\ua788\ua78b-\ua78e\ua790-\ua793\ua7a0-\ua7aa\ua7f8-\ua801\ua803-\ua805\ua807-\ua80a\ua80c-\ua822\ua840-\ua873\ua882-\ua8b3\ua8f2-\ua8f7\ua8fb\ua90a-\ua925\ua930-\ua946\ua960-\ua97c\ua984-\ua9b2\ua9cf\uaa00-\uaa28\uaa40-\uaa42\uaa44-\uaa4b\uaa60-\uaa76\uaa7a\uaa80-\uaaaf\uaab1\uaab5\uaab6\uaab9-\uaabd\uaac0\uaac2\uaadb-\uaadd\uaae0-\uaaea\uaaf2-\uaaf4\uab01-\uab06\uab09-\uab0e\uab11-\uab16\uab20-\uab26\uab28-\uab2e\uabc0-\uabe2\uac00-\ud7a3\ud7b0-\ud7c6\ud7cb-\ud7fb\uf900-\ufa6d\ufa70-\ufad9\ufb00-\ufb06\ufb13-\ufb17\ufb1d\ufb1f-\ufb28\ufb2a-\ufb36\ufb38-\ufb3c\ufb3e\ufb40\ufb41\ufb43\ufb44\ufb46-\ufbb1\ufbd3-\ufd3d\ufd50-\ufd8f\ufd92-\ufdc7\ufdf0-\ufdfb\ufe70-\ufe74\ufe76-\ufefc\uff21-\uff3a\uff41-\uff5a\uff66-\uffbe\uffc2-\uffc7\uffca-\uffcf\uffd2-\uffd7\uffda-\uffdc][$A-Z\_a-z\xaa\xb5\xba\xc0-\xd6\xd8-\xf6\xf8-\u02c1\u02c6-\u02d1\u02e0-\u02e4\u02ec\u02ee\u0370-\u0374\u0376\u0377\u037a-\u037d\u0386\u0388-\u038a\u038c\u038e-\u03a1\u03a3-\u03f5\u03f7-\u0481\u048a-\u0527\u0531-\u0556\u0559\u0561-\u0587\u05d0-\u05ea\u05f0-\u05f2\u0620-\u064a\u066e\u066f\u0671-\u06d3\u06d5\u06e5\u06e6\u06ee\u06ef\u06fa-\u06fc\u06ff\u0710\u0712-\u072f\u074d-\u07a5\u07b1\u07ca-\u07ea\u07f4\u07f5\u07fa\u0800-\u0815\u081a\u0824\u0828\u0840-\u0858\u08a0\u08a2-\u08ac\u0904-\u0939\u093d\u0950\u0958-\u0961\u0971-\u0977\u0979-\u097f\u0985-\u098c\u098f\u0990\u0993-\u09a8\u09aa-\u09b0\u09b2\u09b6-\u09b9\u09bd\u09ce\u09dc\u09dd\u09df-\u09e1\u09f0\u09f1\u0a05-\u0a0a\u0a0f\u0a10\u0a13-\u0a28\u0a2a-\u0a30\u0a32\u0a33\u0a35\u0a36\u0a38\u0a39\u0a59-\u0a5c\u0a5e\u0a72-\u0a74\u0a85-\u0a8d\u0a8f-\u0a91\u0a93-\u0aa8\u0aaa-\u0ab0\u0ab2\u0ab3\u0ab5-\u0ab9\u0abd\u0ad0\u0ae0\u0ae1\u0b05-\u0b0c\u0b0f\u0b10\u0b13-\u0b28\u0b2a-\u0b30\u0b32\u0b33\u0b35-\u0b39\u0b3d\u0b5c\u0b5d\u0b5f-\u0b61\u0b71\u0b83\u0b85-\u0b8a\u0b8e-\u0b90\u0b92-\u0b95\u0b99\u0b9a\u0b9c\u0b9e\u0b9f\u0ba3\u0ba4\u0ba8-\u0baa\u0bae-\u0bb9\u0bd0\u0c05-\u0c0c\u0c0e-\u0c10\u0c12-\u0c28\u0c2a-\u0c33\u0c35-\u0c39\u0c3d\u0c58\u0c59\u0c60\u0c61\u0c85-\u0c8c\u0c8e-\u0c90\u0c92-\u0ca8\u0caa-\u0cb3\u0cb5-\u0cb9\u0cbd\u0cde\u0ce0\u0ce1\u0cf1\u0cf2\u0d05-\u0d0c\u0d0e-\u0d10\u0d12-\u0d3a\u0d3d\u0d4e\u0d60\u0d61\u0d7a-\u0d7f\u0d85-\u0d96\u0d9a-\u0db1\u0db3-\u0dbb\u0dbd\u0dc0-\u0dc6\u0e01-\u0e30\u0e32\u0e33\u0e40-\u0e46\u0e81\u0e82\u0e84\u0e87\u0e88\u0e8a\u0e8d\u0e94-\u0e97\u0e99-\u0e9f\u0ea1-\u0ea3\u0ea5\u0ea7\u0eaa\u0eab\u0ead-\u0eb0\u0eb2\u0eb3\u0ebd\u0ec0-\u0ec4\u0ec6\u0edc-\u0edf\u0f00\u0f40-\u0f47\u0f49-\u0f6c\u0f88-\u0f8c\u1000-\u102a\u103f\u1050-\u1055\u105a-\u105d\u1061\u1065\u1066\u106e-\u1070\u1075-\u1081\u108e\u10a0-\u10c5\u10c7\u10cd\u10d0-\u10fa\u10fc-\u1248\u124a-\u124d\u1250-\u1256\u1258\u125a-\u125d\u1260-\u1288\u128a-\u128d\u1290-\u12b0\u12b2-\u12b5\u12b8-\u12be\u12c0\u12c2-\u12c5\u12c8-\u12d6\u12d8-\u1310\u1312-\u1315\u1318-\u135a\u1380-\u138f\u13a0-\u13f4\u1401-\u166c\u166f-\u167f\u1681-\u169a\u16a0-\u16ea\u16ee-\u16f0\u1700-\u170c\u170e-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176c\u176e-\u1770\u1780-\u17b3\u17d7\u17dc\u1820-\u1877\u1880-\u18a8\u18aa\u18b0-\u18f5\u1900-\u191c\u1950-\u196d\u1970-\u1974\u1980-\u19ab\u19c1-\u19c7\u1a00-\u1a16\u1a20-\u1a54\u1aa7\u1b05-\u1b33\u1b45-\u1b4b\u1b83-\u1ba0\u1bae\u1baf\u1bba-\u1be5\u1c00-\u1c23\u1c4d-\u1c4f\u1c5a-\u1c7d\u1ce9-\u1cec\u1cee-\u1cf1\u1cf5\u1cf6\u1d00-\u1dbf\u1e00-\u1f15\u1f18-\u1f1d\u1f20-\u1f45\u1f48-\u1f4d\u1f50-\u1f57\u1f59\u1f5b\u1f5d\u1f5f-\u1f7d\u1f80-\u1fb4\u1fb6-\u1fbc\u1fbe\u1fc2-\u1fc4\u1fc6-\u1fcc\u1fd0-\u1fd3\u1fd6-\u1fdb\u1fe0-\u1fec\u1ff2-\u1ff4\u1ff6-\u1ffc\u2071\u207f\u2090-\u209c\u2102\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126\u2128\u212a-\u212d\u212f-\u2139\u213c-\u213f\u2145-\u2149\u214e\u2160-\u2188\u2c00-\u2c2e\u2c30-\u2c5e\u2c60-\u2ce4\u2ceb-\u2cee\u2cf2\u2cf3\u2d00-\u2d25\u2d27\u2d2d\u2d30-\u2d67\u2d6f\u2d80-\u2d96\u2da0-\u2da6\u2da8-\u2dae\u2db0-\u2db6\u2db8-\u2dbe\u2dc0-\u2dc6\u2dc8-\u2dce\u2dd0-\u2dd6\u2dd8-\u2dde\u2e2f\u3005-\u3007\u3021-\u3029\u3031-\u3035\u3038-\u303c\u3041-\u3096\u309d-\u309f\u30a1-\u30fa\u30fc-\u30ff\u3105-\u312d\u3131-\u318e\u31a0-\u31ba\u31f0-\u31ff\u3400-\u4db5\u4e00-\u9fcc\ua000-\ua48c\ua4d0-\ua4fd\ua500-\ua60c\ua610-\ua61f\ua62a\ua62b\ua640-\ua66e\ua67f-\ua697\ua6a0-\ua6ef\ua717-\ua71f\ua722-\ua788\ua78b-\ua78e\ua790-\ua793\ua7a0-\ua7aa\ua7f8-\ua801\ua803-\ua805\ua807-\ua80a\ua80c-\ua822\ua840-\ua873\ua882-\ua8b3\ua8f2-\ua8f7\ua8fb\ua90a-\ua925\ua930-\ua946\ua960-\ua97c\ua984-\ua9b2\ua9cf\uaa00-\uaa28\uaa40-\uaa42\uaa44-\uaa4b\uaa60-\uaa76\uaa7a\uaa80-\uaaaf\uaab1\uaab5\uaab6\uaab9-\uaabd\uaac0\uaac2\uaadb-\uaadd\uaae0-\uaaea\uaaf2-\uaaf4\uab01-\uab06\uab09-\uab0e\uab11-\uab16\uab20-\uab26\uab28-\uab2e\uabc0-\uabe2\uac00-\ud7a3\ud7b0-\ud7c6\ud7cb-\ud7fb\uf900-\ufa6d\ufa70-\ufad9\ufb00-\ufb06\ufb13-\ufb17\ufb1d\ufb1f-\ufb28\ufb2a-\ufb36\ufb38-\ufb3c\ufb3e\ufb40\ufb41\ufb43\ufb44\ufb46-\ufbb1\ufbd3-\ufd3d\ufd50-\ufd8f\ufd92-\ufdc7\ufdf0-\ufdfb\ufe70-\ufe74\ufe76-\ufefc\uff21-\uff3a\uff41-\uff5a\uff66-\uffbe\uffc2-\uffc7\uffca-\uffcf\uffd2-\uffd7\uffda-\uffdc0-9\u0300-\u036f\u0483-\u0487\u0591-\u05bd\u05bf\u05c1\u05c2\u05c4\u05c5\u05c7\u0610-\u061a\u064b-\u0669\u0670\u06d6-\u06dc\u06df-\u06e4\u06e7\u06e8\u06ea-\u06ed\u06f0-\u06f9\u0711\u0730-\u074a\u07a6-\u07b0\u07c0-\u07c9\u07eb-\u07f3\u0816-\u0819\u081b-\u0823\u0825-\u0827\u0829-\u082d\u0859-\u085b\u08e4-\u08fe\u0900-\u0903\u093a-\u093c\u093e-\u094f\u0951-\u0957\u0962\u0963\u0966-\u096f\u0981-\u0983\u09bc\u09be-\u09c4\u09c7\u09c8\u09cb-\u09cd\u09d7\u09e2\u09e3\u09e6-\u09ef\u0a01-\u0a03\u0a3c\u0a3e-\u0a42\u0a47\u0a48\u0a4b-\u0a4d\u0a51\u0a66-\u0a71\u0a75\u0a81-\u0a83\u0abc\u0abe-\u0ac5\u0ac7-\u0ac9\u0acb-\u0acd\u0ae2\u0ae3\u0ae6-\u0aef\u0b01-\u0b03\u0b3c\u0b3e-\u0b44\u0b47\u0b48\u0b4b-\u0b4d\u0b56\u0b57\u0b62\u0b63\u0b66-\u0b6f\u0b82\u0bbe-\u0bc2\u0bc6-\u0bc8\u0bca-\u0bcd\u0bd7\u0be6-\u0bef\u0c01-\u0c03\u0c3e-\u0c44\u0c46-\u0c48\u0c4a-\u0c4d\u0c55\u0c56\u0c62\u0c63\u0c66-\u0c6f\u0c82\u0c83\u0cbc\u0cbe-\u0cc4\u0cc6-\u0cc8\u0cca-\u0ccd\u0cd5\u0cd6\u0ce2\u0ce3\u0ce6-\u0cef\u0d02\u0d03\u0d3e-\u0d44\u0d46-\u0d48\u0d4a-\u0d4d\u0d57\u0d62\u0d63\u0d66-\u0d6f\u0d82\u0d83\u0dca\u0dcf-\u0dd4\u0dd6\u0dd8-\u0ddf\u0df2\u0df3\u0e31\u0e34-\u0e3a\u0e47-\u0e4e\u0e50-\u0e59\u0eb1\u0eb4-\u0eb9\u0ebb\u0ebc\u0ec8-\u0ecd\u0ed0-\u0ed9\u0f18\u0f19\u0f20-\u0f29\u0f35\u0f37\u0f39\u0f3e\u0f3f\u0f71-\u0f84\u0f86\u0f87\u0f8d-\u0f97\u0f99-\u0fbc\u0fc6\u102b-\u103e\u1040-\u1049\u1056-\u1059\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d\u108f-\u109d\u135d-\u135f\u1712-\u1714\u1732-\u1734\u1752\u1753\u1772\u1773\u17b4-\u17d3\u17dd\u17e0-\u17e9\u180b-\u180d\u1810-\u1819\u18a9\u1920-\u192b\u1930-\u193b\u1946-\u194f\u19b0-\u19c0\u19c8\u19c9\u19d0-\u19d9\u1a17-\u1a1b\u1a55-\u1a5e\u1a60-\u1a7c\u1a7f-\u1a89\u1a90-\u1a99\u1b00-\u1b04\u1b34-\u1b44\u1b50-\u1b59\u1b6b-\u1b73\u1b80-\u1b82\u1ba1-\u1bad\u1bb0-\u1bb9\u1be6-\u1bf3\u1c24-\u1c37\u1c40-\u1c49\u1c50-\u1c59\u1cd0-\u1cd2\u1cd4-\u1ce8\u1ced\u1cf2-\u1cf4\u1dc0-\u1de6\u1dfc-\u1dff\u200c\u200d\u203f\u2040\u2054\u20d0-\u20dc\u20e1\u20e5-\u20f0\u2cef-\u2cf1\u2d7f\u2de0-\u2dff\u302a-\u302f\u3099\u309a\ua620-\ua629\ua66f\ua674-\ua67d\ua69f\ua6f0\ua6f1\ua802\ua806\ua80b\ua823-\ua827\ua880\ua881\ua8b4-\ua8c4\ua8d0-\ua8d9\ua8e0-\ua8f1\ua900-\ua909\ua926-\ua92d\ua947-\ua953\ua980-\ua983\ua9b3-\ua9c0\ua9d0-\ua9d9\uaa29-\uaa36\uaa43\uaa4c\uaa4d\uaa50-\uaa59\uaa7b\uaab0\uaab2-\uaab4\uaab7\uaab8\uaabe\uaabf\uaac1\uaaeb-\uaaef\uaaf5\uaaf6\uabe3-\uabea\uabec\uabed\uabf0-\uabf9\ufb1e\ufe00-\ufe0f\ufe20-\ufe26\ufe33\ufe34\ufe4d-\ufe4f\uff10-\uff19\uff3f]*$/;

function copyFileSync(source, target) {
    let targetFile = target;

    // If target is a directory, a new file with the same name will be created
    if (fs.existsSync(target)) {
        if (fs.lstatSync(target).isDirectory()) {
            targetFile = path.join(target, path.basename(source));
        }
    }

    fs.writeFileSync(targetFile, fs.readFileSync(source));
}

function copyFolderRecursiveSync(source, target, ignoreFolders = [], ignoreFiles = []) {
    let files = [];

    // Check if folder needs to be created or integrated
    // var targetFolder = path.join( target, path.basename( source ) );
    /* var targetFolder = path.join(target); // EDIT
    if (!fs.existsSync(targetFolder)) {
        fs.mkdirSync(targetFolder);
    } */

    if (!fs.existsSync(target)) {
        fs.mkdirSync(target);
    }

    // Copy
    if (fs.lstatSync(source).isDirectory()) {
        files = fs.readdirSync(source);
        files.forEach(file => {
            var curSource = path.join(source, file);
            var curTarget = curSource.replace(source, target); // NEW, In order to keep the folder structure the same

            if (ignoreFolders.includes(curSource) === true || ignoreFiles.includes(curSource) === true) {
                return;
            }

            if (fs.lstatSync(curSource).isDirectory()) {
                console.log("Copied directory: " + curSource + ", to: " + curTarget);
                // copyFolderRecursiveSync(curSource, targetFolder); // ORIGINAL
                copyFolderRecursiveSync(curSource, curTarget); // NEW
            } else {
                console.log("Copied file: " + curSource + ", to: " + curTarget);
                // copyFileSync(curSource, targetFolder); // ORIGINAL
                copyFileSync(curSource, curTarget); // NEW
            }
        });
    }
}

function isValidVariableName(name) {
    var result = validASCIIVariableNameRegex.exec(name);
    return result !== null && result[0] === name;
}

function isOnlySpaces(text) {
    return text.replace(/\s/g, '').length === 0;
}

/**
 * Get information if it is able to find code that includes a sequence of words, with or without spaces between
 * @param {string} line 
 * @param {string[]} words 
 * @returns {{code: string, index: number}} The information, with parts of the code that matches and it's index
 */
function getCodeThatMatches(line, words, mustEndWith = -1) {
    let startIndex = 0;

    // Keep iterating until we find a complete match or no match at all
    while (line.indexOf(words[0], startIndex) >= 0) {
        startIndex = line.indexOf(words[0], startIndex);

        let lastFoundCharacterIndex = -1;

        for (let i = 0; i < words.length; i++) {
            let characterIndex = line.indexOf(words[i], startIndex);
            if (characterIndex < 0) {
                break;
            }
            if (i > 0 && characterIndex < lastFoundCharacterIndex) {
                break;
            }
            if (i > 0) {
                let lastWord = words[i - 1];
                let start = lastFoundCharacterIndex + lastWord.length;
                let textBetween = line.substring(start, characterIndex);
                if (textBetween.length > 0 && isOnlySpaces(textBetween) === false) {
                    break;
                }
            }
            if (i === words.length - 1) {
                let lastWord = words[words.length - 1];
                let match = {
                    code: line.substring(startIndex, characterIndex + lastWord.length),
                    index: startIndex
                }
                if (validateMustEndWith(line, match.code, match.index, mustEndWith) == true) {
                    return match;
                }
            }
            lastFoundCharacterIndex = characterIndex;
        }
        startIndex++;
    }

    return {
        code: "",
        index: -1
    }
}

function validateMustEndWith(fullLine, part, partIndex, mustEndWith) {
    let characterAfterPart = fullLine[partIndex + part.length];

    if (mustEndWith === MUST_END_WITH_NO_CHARACTER) {
        if (characterAfterPart != "") {
            return false;
        }
    }
    if (mustEndWith === MUST_END_WITH_ANY_CHARACTER) {
        if (characterAfterPart == "") {
            return false;
        }
    }
    if (mustEndWith === MUST_END_WITH_VALID_VARIABLE_CHARACTER) {
        // We add "a", so that if it finds just a number, for example, then it's still valid
        if (characterAfterPart == "" || isValidVariableName("a" + characterAfterPart) == false) {
            return false;
        }
    }
    if (mustEndWith === MUST_END_WITH_INVALID_VARIABLE_CHARACTER) {
        // We treat no character as invalid as well, so when it's the last word of the line, it doesn't return false
        if (characterAfterPart != "" && isValidVariableName("a" + characterAfterPart) == true) {
            return false;
        }
    }

    return true;
}

/**
 * Get the index of an Actionscript line based on certain criteria
 * @param {string[]} lines The lines of code to search in
 * @param {string[]} words The words/text to find in order, if it finds them in a different order, it doesn't count
 * @param {number} mustEndWithAny The type of character that comes after the last word, if omitted, it can end with any
 * @returns The index of the the valid line
 */
function findActionScriptLineIndex(lines, words, mustEndWith = -1) {
    const lastWord = words[words.length - 1];
    
    return lines.findIndex(line => {
        const commentIndex = line.indexOf("//");

        const wordIndexes = words.map(word => {
            return line.indexOf(word);
        });

        const lowestWordIndex = Math.min(...wordIndexes);
        const highestWordIndex = Math.max(...wordIndexes);

        // If at least one word wasn't found, return false
        if (lowestWordIndex < 0) {
            return false;
        }

        // If each word is not in the correct order, return false
        for (let i = 0; i < wordIndexes.length; i++) {
            if (i > 0 && wordIndexes[i - 1] > wordIndexes[i]) {
                return false;
            }
        }

        // If the comment comes before any word, return false
        if (commentIndex >= 0 && commentIndex < highestWordIndex) {
            return false;
        }

        var lastIndex = highestWordIndex + lastWord.length;
        var characterAfterLastWord = line.length > lastIndex ? line[lastIndex] : "";

        if (mustEndWith === MUST_END_WITH_NO_CHARACTER) {
            if (characterAfterLastWord != "") {
                return false;
            }
        }
        if (mustEndWith === MUST_END_WITH_ANY_CHARACTER) {
            if (characterAfterLastWord == "") {
                return false;
            }
        }
        if (mustEndWith === MUST_END_WITH_VALID_VARIABLE_CHARACTER) {
            // We add "a", so that if it finds just a number, for example, then it's still valid
            if (characterAfterLastWord == "" || isValidVariableName("a" + characterAfterLastWord) == false) {
                return false;
            }
        }
        if (mustEndWith === MUST_END_WITH_INVALID_VARIABLE_CHARACTER) {
            // We treat no character as invalid as well, so when it's the last word of the line, it doesn't return false
            if (characterAfterLastWord != "" && isValidVariableName("a" + characterAfterLastWord) == true) {
                return false;
            }
        }

        return true;
    });
}

function findActionScriptLineIndexes(lines, words) {
    const indexes = [];
    for (let i = 0; i < lines.length; i++) {
        const index = i + findActionScriptLineIndex(lines.slice(i), words);
        if (index >= i) {
            indexes.push(index);
            i = index;
        } else {
            break;
        }
    }
    return indexes;
}

/**
 * 
 * @param {string[]} lines Lines of code
 * @param {string[]} words A sequence of words to match, with or without spaces between 
 * @returns {{line: string, lineIndex: number, match: string, matchIndex: number}[]}
 */
function findActionScriptLines(lines, words, mustEndWith = -1) {
    const result = [];
    for (let i = 0; i < lines.length; i++) {
        const match = getCodeThatMatches(lines[i], words, mustEndWith);
        if (match.index >= 0) {
            result.push({
               line: lines[i],
               lineIndex: i,
               match: match.code,
               matchIndex: match.index
            });
        }
    }
    return result;
}

function removeActionScriptLines(lines, words) {
    while (findActionScriptLineIndex(lines, words) >= 0) {
        const index = findActionScriptLineIndex(lines, words);
        lines.splice(index, 1);
    }
}

/* function replaceInActionScriptLines(lines, words, find, replace) {
    const indexes = findActionScriptLineIndexes(lines, words);
    for (let i of indexes) {
        lines[i] = lines[i].split(find).join(replace);
    }
} */

/**
 * @param {string[]} lines 
 * @param {string[]} words 
 * @param {string} replaceWith
 */
function replaceInActionScriptLines(lines, words, replaceWith, mustEndWith = -1) {
    const lineInfos = findActionScriptLines(lines, words, mustEndWith);
    for (let info of lineInfos) {
        lines[info.lineIndex] = lines[info.lineIndex].replace(info.match, replaceWith);
    }
}

function getStringBetween(string, leftPart, rightPart) {
    return string.substring(string.indexOf(leftPart) + leftPart.length, string.indexOf(rightPart));
}

function validateActionscript3ForTranspilation(actionscript) {
    const lines = actionscript.split("\r\n");
    const warnings = [];

    const classLineIndex = findActionScriptLineIndex(lines, ["public class"]);
    const className = getStringBetween(lines[classLineIndex], "class ", " {");

    const constructorLineIndex = lines.findIndex(line => line.includes("function " + className + "("));

    // Check for new Instance declarations above the constructor
    const newInstanceDeclarationIndexes = findActionScriptLineIndexes(lines, ["var ", " = new "]);

    for (let i = 0; i < newInstanceDeclarationIndexes.length; i++) {
        if (newInstanceDeclarationIndexes[i] < constructorLineIndex) {
            warnings.push("Warning: new Instance declaration above the constructor, in " + className);
        }
    }

    const unsupportedDataTypes = ["int", "Class", "Event"];
    for (let unsupportedDataType of unsupportedDataTypes) {
        const dataTypelines = findActionScriptLines(lines, [":", unsupportedDataType], MUST_END_WITH_INVALID_VARIABLE_CHARACTER);
        for (let line of dataTypelines) {
            warnings.push("Warning: " + unsupportedDataType + " data type used, which is not supported in AS2, line: " + (line.lineIndex + 1));
        }
    }

    // AS2 doesn't support calculations like: 10 * +0.05
    // AS2 doesn't support multiple class properties with the same name, even if the accessor is different¨
    // There should be a warning for any of the custom event listeners, where you have to pass "this", if you also pass an annonymous function, or a function that isn't declared in the same file
    // Annonymous functions tend to cause issues, invalidate if found
    // For loops, in AS2, the iterator variable can't be defined in one loop, and then reused again in later loop, if it's the same name, it has to be defined before both loops

    if (warnings.length > 0) {
        console.log(warnings.join("\n"));
    }
    
    return warnings.length == 0;
}

function checkForPotentialIssuesInActionscript(actionscript) {
    const lines = actionscript.split("\r\n");
    const issues = [];

    const properties = [
        // AS2/AS3 MovieClip
        "alpha", "currentFrame", "framesLoaded", "name", "height", "parent", "rotation", "totalFrames", "visible", "width", "x", "y",
        "scaleX", "scaleY"
    ]

    for (let property of properties) {
        const propertylines = findActionScriptLines(lines, [".", property], MUST_END_WITH_INVALID_VARIABLE_CHARACTER);
        for (let line of propertylines) {
            console.log("Potential issue: " + property + " property used, line: " + line.lineIndex);
            console.log("Line: " + line.line);
        }
    }

    return issues.length == 0;
}

function transpileActionScript3To2(actionscript) {
    const warnings = [];

    let lines = actionscript.split("\r\n");

    let packageLineIndex = findActionScriptLineIndex(lines, ["package ", "{"]);

    if (packageLineIndex < 0) {
        return actionscript;
    }

    packageLineIndex = findActionScriptLineIndex(lines, ["package ", "{"]);
    const packageLine = lines[packageLineIndex];
    const packageName = getStringBetween(packageLine, "package", "{").trim();

    // Import everything from the base package, incase something else from it is being used, as AS3 doesn't require import for that
    if (packageName !== "") {
        const packageNameStart = packageName.split(".")[0];
        lines.unshift("");
        lines.unshift("import " + packageNameStart + ".*");
    }

    // Add transpiler info
    lines.unshift("");
    lines.unshift(" */");
    lines.unshift(" * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again");
    lines.unshift("/**");

    let emptyLinesAfterPackage = 0;
    for (let i = packageLineIndex + 1; i < lines.length; i++) {
        if (lines[i].trim() === "") {
            emptyLinesAfterPackage++;
        } else {
            break;
        }
    }

    // Remove package line and any empty lines after
    removeActionScriptLines(lines, ["package ", "{"]);

    // Remove 1 indentation from each line
    for (let i = 0; i < lines.length; i++) {
        lines[i] = lines[i].replace("\t", "");
    }

    // Remove last closing curly bracket
    const closingBracketIndexes = findActionScriptLineIndexes(lines, ["}"]);
    const lastClosingBracketIndex = closingBracketIndexes[closingBracketIndexes.length - 1];
    lines.splice(lastClosingBracketIndex, 1);

    // Replace imports
    replaceInActionScriptLines(lines, ["flash.ui.Keyboard"], "core.Keyboard", MUST_END_WITH_INVALID_VARIABLE_CHARACTER);

    // Remove standard imports
    removeActionScriptLines(lines, ["import flash.display"]);

    const classLineIndex = findActionScriptLineIndex(lines, ["public class"]);

    // Transpile class line
    const classLineParts = lines[classLineIndex].split("public class ");
    if (packageName !== "") {
        classLineParts.splice(1, 0, "class " + packageName + ".");
    } else {
        classLineParts.splice(1, 0, "class ");
    }
    lines[classLineIndex] = classLineParts.join("");

    // Repace : void with : Void
    replaceInActionScriptLines(lines, [":", "void"], ": Void", MUST_END_WITH_INVALID_VARIABLE_CHARACTER);

    // Repace : DisplayObjectContainer with : MovieClip
    replaceInActionScriptLines(lines, [":", "DisplayObjectContainer"], ": MovieClip", MUST_END_WITH_INVALID_VARIABLE_CHARACTER);

    // Repace : DisplayObject with : MovieClip
    replaceInActionScriptLines(lines, [":", "DisplayObject"], ": MovieClip", MUST_END_WITH_INVALID_VARIABLE_CHARACTER);

    // Repace : Sprite with : MovieClip
    replaceInActionScriptLines(lines, [":", "Sprite"], ": MovieClip", MUST_END_WITH_INVALID_VARIABLE_CHARACTER);

    // TODO: Fix (var child : DisplayObject) // Without semi-colon

    // Remove : * (any type declaration)
    replaceInActionScriptLines(lines, [":", "*"], "", MUST_END_WITH_INVALID_VARIABLE_CHARACTER);

    return lines.join("\r\n");
}

function transpileActionScriptFiles(target, ignoreFolders = [], ignoreFiles = []) {
    if (fs.lstatSync(target).isDirectory() === false) {
        throw new Error("Unable to transpile actionscript, the target directory: " + target + " doesn't exist");
    }

    let isAborted = false;

    files = fs.readdirSync(target);
    files.forEach(file => {
        if (isAborted) {
            return;
        }

        const filePath = path.join(target, file);
        if (fs.lstatSync(filePath).isDirectory() === true && ignoreFolders.includes(filePath) === false) {
            transpileActionScriptFiles(filePath);
        } else if (filePath.includes(".as") === true && ignoreFiles.includes(filePath) === false) {
            fs.readFile(filePath, "utf-8", (err, data) => {
                console.log("Transpiling: " + filePath);
                const isValid = validateActionscript3ForTranspilation(data);
                if (isValid === false) {
                    console.log("Warnings found in: " + filePath);
                    console.log("Aborting");
                    isAborted = true;
                    return;
                }
                const transpiled = transpileActionScript3To2(data);
                fs.writeFile(filePath, transpiled, "utf-8", (err) => {
                    if (err) {
                        throw err
                    }
                });
            });
        }
    });
}

console.log("--------------------------------------------------------------------------------");
copyFolderRecursiveSync("flash-toy-sync-as3\\src", "flash-toy-sync-as2\\src", ["flash-toy-sync-as3\\src\\core"], ["flash-toy-sync-as3\\src\\Main.as"]);
transpileActionScriptFiles("flash-toy-sync-as2\\src", ["flash-toy-sync-as2\\src\\core"], ["flash-toy-sync-as2\\src\\Main.as"]);
console.log("--------------------------------------------------------------------------------");