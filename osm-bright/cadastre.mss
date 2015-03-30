#vic_cadastre[zoom>=18] {
  line-color: #333333;
  line-join: round;
  line-cap: round;
  [zoom=18] {
    line-width: 0.3;
  }
  [zoom=19] {
    line-width: 0.4;
  }
  [zoom=20] {
    line-width: 0.5;
  }
}

#vic_address[zoom>=19] {
  text-name: [num_add];
  text-face-name: @sans;
  text-fill: #555555;
  [zoom=19] {
    text-size: 4 + @text_adjust;
  }
  [zoom=20] {
    text-size: 6 + @text_adjust;
  }
}
