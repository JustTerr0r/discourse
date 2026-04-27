import icon from "discourse/helpers/d-icon";

<template>
  <div class="leaderboard">
    <div class="leaderboard__podium">
      <div class="leaderboard__card rank-2">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--silver">U2</div>
          <span class="leaderboard__badge">2</span>
        </div>
        <span class="leaderboard__name">user_2</span>
        <span class="leaderboard__score">{{icon "star"}} 3.2M</span>
      </div>

      <div class="leaderboard__card rank-1">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--gold">U1</div>
          <span class="leaderboard__badge">1</span>
        </div>
        <span class="leaderboard__name">user_1</span>
        <span class="leaderboard__score">{{icon "star"}} 4M</span>
      </div>

      <div class="leaderboard__card rank-3">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--bronze">U3</div>
          <span class="leaderboard__badge">3</span>
        </div>
        <span class="leaderboard__name">user_3</span>
        <span class="leaderboard__score">{{icon "star"}} 1.4M</span>
      </div>
    </div>

    <div class="leaderboard__grid">
      <div class="leaderboard__card rank-4">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--4">U4</div>
          <span class="leaderboard__badge">4</span>
        </div>
        <span class="leaderboard__name">user_4</span>
        <span class="leaderboard__score">{{icon "star"}} 1.3M</span>
      </div>

      <div class="leaderboard__card rank-5">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--5">U5</div>
          <span class="leaderboard__badge">5</span>
        </div>
        <span class="leaderboard__name">user_5</span>
        <span class="leaderboard__score">{{icon "star"}} 1.1M</span>
      </div>

      <div class="leaderboard__card rank-6">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--6">U6</div>
          <span class="leaderboard__badge">6</span>
        </div>
        <span class="leaderboard__name">user_6</span>
        <span class="leaderboard__score">{{icon "star"}} 1M</span>
      </div>

      <div class="leaderboard__card rank-7">
        <div class="leaderboard__avatar-wrap">
          <div class="leaderboard__avatar leaderboard__avatar--7">U7</div>
          <span class="leaderboard__badge">7</span>
        </div>
        <span class="leaderboard__name">user_7</span>
        <span class="leaderboard__score">{{icon "star"}} 772.2K</span>
      </div>
    </div>
  </div>
</template>
